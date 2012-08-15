# == Schema Information
#
# Table name: organizations
#
#  id                :integer         not null, primary key
#  name              :string(255)
#  phone             :string(255)
#  website           :string(255)
#  company           :string(255)
#  address1          :string(255)
#  address2          :string(255)
#  city              :string(255)
#  state             :string(255)
#  zip               :string(255)
#  country           :string(255)
#  mobile            :string(255)
#  work_phone        :string(255)
#  email             :string(255)
#  subcontrax_member :boolean
#  status            :integer
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#

class Organization < ActiveRecord::Base
  has_many :users
  has_many :customers, inverse_of: :organization
  has_many :org_to_roles
  has_many :organization_roles, :through => :org_to_roles

  has_many :service_calls, :inverse_of => :organization


  # agreements is the table tha holds the link between an organization er and its providers and subcontractors
  has_many :agreements, foreign_key: "provider_id", class_name: "Agreement"
  # subcontractors are a set of subcontractors which this organization has an agreement with
  has_many :subcontractors, through: :agreements, source: :subcontractor
  # the reverse agreements is a symbol creating a form of a virtual table that will allow the creation of
  # the below providers relationship
  has_many :reverse_agreements, foreign_key: "subcontractor_id",
           class_name: "Agreement"
  # providers are made available thanks to the reverse relationship virtual table above
  has_many :providers, through: :reverse_agreements, source: :provider


  attr_accessible :address1,
                  :address2,
                  :city,
                  :company,
                  :country,
                  :email,
                  :mobile,
                  :name,
                  :phone,
                  :state,
                  :status_event,
                  :website,
                  :work_phone,
                  :zip, :organization_role_ids, :provider_id

  # accessing associated models
  attr_accessible :users_attributes, :provider_attributes, :agreement_attributes, :agreements

  accepts_nested_attributes_for :users, :agreements

  validates :name, {presence: true, length: {maximum: 255}}

  validate :has_at_least_one_role
  validates_presence_of :organization_roles
  validates_with OneOwnerValidator

  includes :organization_roles


  scope :members, -> { where("subcontrax_member = true") }
  scope :providers, -> { includes(:organization_roles).where("organization_roles.id = ? ", OrganizationRole::PROVIDER_ROLE_ID) }
  scope :provider_members, -> { members.providers }
  scope :associated_providers, -> { providers.includes(:agreements) }
  scope :my_providers, ->(org_id) { associated_providers.where('agreements.subcontractor_id = ?', org_id) - where(id: org_id) }
  scope :search, ->(query) { where(arel_table[:name].matches("%#{query}%")) }

  scope :provider_search, ->(org_id, query) { (search(query).provider_members - where(id: org_id)| search(query).my_providers(org_id)).order('organizations.name') }

  # State machine  for Organization status

  # first we will define the organization state values
  STATUS_NEW = 0
  STATUS_LOCAL_ENABLED = 1
  STATUS_LOCAL_DISABLED = -1
  STATUS_SBCX_ACTIVE_MEMBER = 2
  STATUS_SBCX_INACTIVE_MEMBER =-2

  # The state machine definitions
  state_machine :status, :initial => :new do
    state :new, value: STATUS_NEW # no organization should be set with this initial state
    state :local_enabled, value: STATUS_LOCAL_ENABLED # a local organization is a private provider or subcontractor associated with another organization
    state :local_disabled, value: STATUS_LOCAL_DISABLED
    state :sbcx_member, value: STATUS_SBCX_ACTIVE_MEMBER
    state :sbcx_member_disabled, value: STATUS_SBCX_INACTIVE_MEMBER

    before_transition :new => :sbcx_member, :do => :make_member
    after_transition :new => :local_enabled, :do => :alert_local

    event :make_local do
      transition :new => :local_enabled
    end

    event :disable_local do
      transition :local_enabled => :local_disabled
    end

    event :enable_local do
      transition :local_disabled => :local_enabled
    end

    event :make_sbcx_member do
      transition :new => :sbcx_member
    end

    event :disable_sbcx_memeber do
      transition :sbcx_member => :sbcx_member_disabled
    end

    event :enable_sbcx_memeber do
      transition :sbcx_member_disabled => :sbcx_member
    end


  end

  def make_member
    self.subcontrax_member=true
    Rails.logger.debug "#{self.name} has been created as a MEMBER!"
  end

  def alert_local
    Rails.logger.debug "#{self.name} has been created as LOCAL!"
  end

  def provider?
    organization_role_ids.include? OrganizationRole::PROVIDER_ROLE_ID
  end

  def subcontractor?
    organization_role_ids.include? OrganizationRole::SUBCONTRACTOR_ROLE_ID
  end

  def create_provider!(params)
    params[:provider][:organization_role_ids] = [OrganizationRole::PROVIDER_ROLE_ID]

    providers.create!(params[:provider])

    # todo ensure both provider and new are in the same transaction

  end

  def add_provider(provider)
    providers << provider
  end

  def create_subcontractor!(params)
    params[:organization_role_ids] = [OrganizationRole::SUBCONTRACTOR_ROLE_ID]

    subcontractors.create!(params[:subcontractor])
    #subcontractors.build(params[:subcontractor]).save

    # todo ensure both subcontractor and new are in the same transaction

  end

  def add_subcontractor(subcontractor)
    subcontractors << subcontractor
  end

  def provider_candidates(org_id, search)
    # todo fix the bug where all organizations are returned
    if search
      Provider.provider_members | self.providers
      #prov_members = Organization.provider_members(search).order(:id)
      #local_prov = providers.where('organizations.name LIKE ?', "%#{search}%").order(:id)
      #
      #local_prov.merge(prov_members)

      #Organization.local_and_candidate_providers(search)
      #Organization.all(:conditions => ['name LIKE ?', "%#{search}%"])
    else
      Provider.search_providers(org_id, '')
      #Organization.local_and_candidate_providers(search)
      #Organization.all
    end

  end

  def subcontractor_candidates(search)
    # todo fix the bug where all organizations are returned
    if search
      local_and_candidate_providers
      #Organization.all(:conditions => ['name LIKE ?', "%#{search}%"])
    else
      local_and_candidate_providers
    end

  end

  def customer_candidates(search)
    # todo fix the bug where all organizations are returned
    if search
      customers.where('name LIKE ?', "%#{search}%")
    else
      customers
    end

  end

  #def initialize
  #  super()
  #end

  private
  def has_at_least_one_role
    errors.add(:organization_roles, "You must select at least one organization role") unless organization_roles.length > 0
  end


end
