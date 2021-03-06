# == Schema Information
#
# Table name: organizations
#
#  id                :integer          not null, primary key
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
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  parent_org_id     :integer
#  industry          :string(255)
#  other_industry    :string(255)
#

require 'hstore_setup_methods'
class Organization < ActiveRecord::Base
  extend HstoreSetupMethods
  serialize :properties, ActiveRecord::Coders::Hstore
  setup_hstore_attr 'default_tax'

  def default_tax
    (properties['default_tax'].nil? || properties['default_tax'].empty?) ? '0' : properties['default_tax']
  end

  def self.industries
    [
        :locksmith,
        :security_systems,
        :carpet_cleaning,
        :plumbing,
        :electricity,
        :construction,
        :transportation,
        :landscaping,
        :towing,
        :auto_repair,
        :glass_repair,
        :photography,
        :other
    ]
  end

  def self.human_industry_name(industry)
    (industry && industries.include?(industry.to_sym)) ? I18n.t("organization.industries.#{industry}") : ''
  end

  ### ASSOCIATIONS:
  has_many :invites
  has_many :invite_req, class_name: 'Invite', foreign_key: 'affiliate_id'
  has_many :users
  has_many :customers, inverse_of: :organization do
    #def << (customer)
    #  customer.build_account(organization: proxy_association.owner)
    #  customer.agreements << CustomerAgreement.new(organization: proxy_association.owner, creator: User.find_by_email('system@subcontrax.com'))
    #  customer.save!
    #end

  end
  has_many :org_to_roles
  has_many :organization_roles, :through => :org_to_roles
  has_many :service_calls, :inverse_of => :organization
  has_many :tickets, :inverse_of => :organization
  has_many :projects, :inverse_of => :organization
  has_many :events, as: :eventable, :order => 'id DESC'
  has_many :materials
  has_many :accounts
  belongs_to :parent_org, class_name: 'Organization', foreign_key: 'parent_org_id'
  has_many :affiliates, through: :accounts, source: :accountable, :source_type => "Organization" do
    def build(params)
      affiliate            = Affiliate.new(params)
      affiliate.status     = STATUS_LOCAL_ENABLED
      affiliate.parent_org = proxy_association.owner
      #proxy_association.owner.providers << affiliate if affiliate.organization_role_ids.include? OrganizationRole::PROVIDER_ROLE_ID
      #proxy_association.owner.subcontractors << affiliate if affiliate.organization_role_ids.include? OrganizationRole::SUBCONTRACTOR_ROLE_ID
      affiliate
    end
  end
  has_many :agreements, inverse_of: :organization
  has_many :subcontracting_agreements, inverse_of: :organization do
    def build(params)
      agreement                  = super
      agreement.counterparty_type= "Organization"
      agreement
    end
  end
  has_many :reverse_agreements, class_name: "Agreement", :foreign_key => "counterparty_id", inverse_of: :organization
  has_many :subcontractors, class_name: "Organization", through: :agreements, source: :counterparty, source_type: "Organization", :conditions => "agreements.type = 'SubcontractingAgreement' AND agreements.status = #{OrganizationAgreement::STATUS_ACTIVE}", uniq: true do
    def << (subcontractor)

      unless subcontractor.member?
        subcontractor.parent_org_id = proxy_association.owner.id
        return subcontractor unless subcontractor.valid?
      end

      unless subcontractor.reverse_agreements.where(:organization_id => proxy_association.owner.id).first
        subcon_creator = subcontractor.creator ? subcontractor.creator : User.find_by_email(User::SYSTEM_USER_EMAIL)
        Agreement.with_scope(:create => { type: "SubcontractingAgreement", creator: subcon_creator, name: FlatFee.model_name.titleize, payment_terms: Agreement.payment_options[:net_15] }) { self.concat subcontractor }
        agr = subcontractor.reverse_agreements.where(:organization_id => proxy_association.owner.id).first
        agr.rules << FlatFee.new
        agr.status = Agreement::STATUS_ACTIVE
        agr.save!
        Rails.logger.debug { "Created a default flat fee agreement for subcontractor:\n#{agr.inspect}" }
      end
      proxy_association.owner.affiliates << subcontractor unless proxy_association.owner.affiliates.include? subcontractor
      subcontractor
    end

  end
  has_many :providers, class_name: "Organization", :through => :reverse_agreements, source: :organization, :conditions => "agreements.type = 'SubcontractingAgreement' AND agreements.status = #{OrganizationAgreement::STATUS_ACTIVE}", uniq: true do
    def << (provider)
      unless provider.member?
        provider.parent_org_id = proxy_association.owner.id
        return provider unless provider.valid?
      end

      unless provider.agreements.where(:counterparty_id => proxy_association.owner.id, counterparty_type: 'Organization').first
        prov_creator = provider.creator ? provider.creator : User.find_by_email(User::SYSTEM_USER_EMAIL)
        Agreement.with_scope(:create => { type: "SubcontractingAgreement", counterparty_type: "Organization", creator: prov_creator, name: FlatFee.model_name.titleize, payment_terms: Agreement.default_payment_term }) { self.concat provider }
        agr = provider.agreements.where(:counterparty_id => proxy_association.owner.id, counterparty_type: "Organization").first
        agr.rules << FlatFee.new
        agr.status = Agreement::STATUS_ACTIVE
        agr.save!
        Rails.logger.debug { "Created a default flat fee agreement for provider:\n#{agr.inspect}" }
      end
      proxy_association.owner.affiliates << provider unless proxy_association.owner.affiliates.include? provider
      provider
    end
  end
  has_many :boms, as: :buyer
  has_many :tags
  has_many :appointments

  ### VALIDATIONS:

  accepts_nested_attributes_for :users, :agreements, :reverse_agreements

  validates_uniqueness_of :name, scope: :parent_org_id, unless: ->(subcon) { subcon.member? }

  validates :name, { presence: true, length: { maximum: 255 } }

  validate :has_at_least_one_role
  validates_presence_of :organization_roles
  validates_presence_of :industry, unless: ->(org) { org.kind_of?(Affiliate) }
  validates_presence_of :email, if: ->(org) { org.member? }

  validates_with OneOwnerValidator
  validates_uniqueness_of :name, scope: [:subcontrax_member], if: Proc.new { |org| org.subcontrax_member }
  validate :check_industry, unless: ->(org) { org.kind_of?(Affiliate) }
  validates_email_format_of :email, allow_nil: true, allow_blank: true

  ### EAGER LOADS:
  includes :organization_roles

  ### SCOPES:
  scope :members, -> { where(:subcontrax_member => true) }
  scope :providers, -> { includes(:organization_roles).where("organization_roles.id = ? ", OrganizationRole::PROVIDER_ROLE_ID) }
  scope :subcontractors, -> { includes(:organization_roles).where("organization_roles.id = ? ", OrganizationRole::SUBCONTRACTOR_ROLE_ID) }
  scope :subcontractor_members, -> { members.subcontractors }
  scope :provider_members, -> { members.providers }
  scope :the_affiliates, ->(org) { joins("INNER JOIN agreements on ((agreements.organization_id = organizations.id OR agreements.counterparty_id = organizations.id) AND agreements.counterparty_type = 'Organization') WHERE (agreements.organization_id = #{org.id} OR agreements.counterparty_id = #{org.id}) AND organizations.id != #{org.id}").uniq }
  scope :associated_providers, -> { providers.includes(:agreements) }
  scope :associated_subcontractors, -> { subcontractors.includes(:reverse_agreements) }
  scope :my_providers, ->(org_id) { associated_providers.where('agreements.counterparty_id = ?', org_id) - where(id: org_id) }
  scope :my_subcontractors, ->(org_id) { associated_subcontractors.where('agreements.organization_id = ?', org_id) - where(id: org_id) }
  scope :my_affiliates, ->(org_id) { (associated_providers | associated_subcontractors).where('agreements.counterparty_id = ? OR agreements.organization_id = ?', org_id, org_id) - where(id: org_id) }
  scope :search, ->(query) { where('organizations.name @@ :q OR organizations.company @@ :q', q: query) }
  scope :provider_search, ->(org_id, query) { (search(query).provider_members - where(id: org_id)| search(query).my_providers(org_id)).order('organizations.name') }
  scope :subcontractor_search, ->(org_id, query) { ((search(query).subcontractor_members - where(id: org_id)| search(query).my_subcontractors(org_id)).order('organizations.name')) }
  scope :affiliate_search, ->(org_id, query) { (my_affiliates(org_id).search(query) | members.search(query) - where(id: org_id)).order('organizations.name ASC') }

  def technicians(columns = "")
    User.my_technicians(self.id, columns)
  end

  def org_admins
    User.my_admins(self.id)
  end

  # State machine  for Organization status

  # first we will define the organization state values
  STATUS_NEW                  = 0
  STATUS_LOCAL_ENABLED        = 1
  STATUS_LOCAL_DISABLED       = -1
  STATUS_SBCX_ACTIVE_MEMBER   = 2
  STATUS_SBCX_INACTIVE_MEMBER =-2

  # The state machine definitions
  state_machine :status, :initial => :new do
    state :new, value: STATUS_NEW                     # no organization should be set with this initial state
    state :local_enabled, value: STATUS_LOCAL_ENABLED # a local organization is a private provider or subcontractor associated with another organization
    state :local_disabled, value: STATUS_LOCAL_DISABLED
    state :sbcx_member, value: STATUS_SBCX_ACTIVE_MEMBER
    state :sbcx_member_disabled, value: STATUS_SBCX_INACTIVE_MEMBER

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
    self.subcontrax_member  = true
    self.organization_roles = [OrganizationRole.find(OrganizationRole::PROVIDER_ROLE_ID),
                               OrganizationRole.find(OrganizationRole::SUBCONTRACTOR_ROLE_ID)]
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

  def one_of_my_local_providers?(org_id)
    !Organization.find(org_id).subcontrax_member? &&
        !Organization.my_providers(self.id).where("organizations.id = ?", org_id).limit(1).empty?
  end

  def multi_user?
    self.users.size > 1
  end

  def my_customer?(customer)
    Customer.where("id = ? AND organization_id = ?", customer.id, self.id).size > 0
  end

  def my_user?(user)
    User.where("id = ? AND organization_id = ?", user.id, self.id).size > 0
  end

  def account_for(org)
    Account.where("organization_id = #{self.id} AND accountable_id = #{org.id} AND accountable_type = '#{org.class.name}'").first
  end

  def affiliate_jobs_for(org)
    Ticket.affiliated_jobs(self, org)
  end

  def open_affiliate_jobs_for(org)
    Ticket.open_affiliated_jobs(self, org)
  end

  def member?
    self.subcontrax_member?
  end

  def local?
    !member?
  end

  def industry_name
    other_industry || Organization.human_industry_name(industry)
  end

  def open_jobs
    ServiceCall.open_jobs(self).all
  end

  def active_jobs
    ServiceCall.active_jobs(self).order('id desc')
  end

  def my_affiliate?(aff)
    affiliate_ids.include? aff.id
  end

  def settings
    @settings ||= OrgSettings.new(self)
  end

  private
  def has_at_least_one_role
    errors.add(:organization_roles, "You must select at least one organization role") unless organization_roles.length > 0
  end

  def check_industry
    errors.add :industry, "Invalid industry provided" unless industry_valid?
    errors.add :other_industry, "You must specify the other industry when choosing other" if other_industry_missing?
  end

  def industry_valid?
    self.industry && self.class.industries.include?(self.industry.to_sym)
  end

  def other_industry_missing?
    industry && industry.to_sym == :other && other_industry.blank?
  end


end
