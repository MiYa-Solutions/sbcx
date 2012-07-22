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
                  :status,
                  :website,
                  :work_phone,
                  :zip, :organization_role_ids, :provider_id

  # accessing associated models
  attr_accessible :users_attributes, :provider_attributes, :agreement_attributes, :agreements


  accepts_nested_attributes_for :users, :agreements

  validates :name, {presence: true, length: {maximum: 255}}

  validate :has_at_least_one_role

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

  def provider_candidates(search)
    # todo fix the bug where all organizations are returned
    if search
      Organization.all(:conditions => ['name LIKE ?', "%#{search}%"])
    else
      Organization.all
    end

  end

  def subcontractor_candidates(search)
    # todo fix the bug where all organizations are returned
    if search
      Organization.all(:conditions => ['name LIKE ?', "%#{search}%"])
    else
      Organization.all
    end

  end

  def customer_candidates(search)
    # todo fix the bug where all organizations are returned
    if search
      customers(:conditions => ['name LIKE ?', "%#{search}%"])
    else
      customers
    end

  end

  private
  def has_at_least_one_role
    errors.add(:organization_roles, "You must select at least one organization role") unless organization_roles.length > 0
  end


end
