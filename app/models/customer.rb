# == Schema Information
#
# Table name: customers
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  organization_id :integer
#  company         :string(255)
#  address1        :string(255)
#  address2        :string(255)
#  city            :string(255)
#  state           :string(255)
#  zip             :string(255)
#  country         :string(255)
#  phone           :string(255)
#  mobile_phone    :string(255)
#  work_phone      :string(255)
#  email           :string(255)
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  creator_id      :integer
#  updater_id      :integer
#

class Customer < ActiveRecord::Base
  belongs_to :organization, inverse_of: :customers
  has_many :service_calls, :inverse_of => :customer
  has_many :agreements, as: :counterparty
  has_one :account, as: :accountable
  stampable

  validates_presence_of :organization
  validates_presence_of :name
  validates_email_format_of :email, allow_nil: true, allow_blank: true

  after_create :set_default_agreement


  scope :search, ->(query, org_id) { fellow_customers(org_id).where(arel_table[:name].matches("%#{query}%")) }
  scope :fellow_customers, ->(org_id) { where(:organization_id => org_id) }
  private
  def set_default_agreement
    agr_name                    = JobCharge.model_name.human
    cus_agreement               = CustomerAgreement.create(name: agr_name, counterparty: self, organization: self.organization, creator: User.find_by_email('system@subcontrax.com'))
    cus_agreement.posting_rules = [JobCharge.new(agreement: cus_agreement, rate: 0, rate_type: :percentage)]
    self.create_account(organization: self.organization)
    self.agreements = [cus_agreement]
    self
  end

  STATUS_ACTIVE = 1
  STATUS_DISABLED = 0
  state_machine :status, initial: :active do
    state :active, value: STATUS_ACTIVE
    state :disabled, value: STATUS_DISABLED

    event :activate do
      transition :disabled => :active
    end

    event :disable do
      transition :active => :disabled
    end
  end

end
