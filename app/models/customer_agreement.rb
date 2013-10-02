# == Schema Information
#
# Table name: agreements
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  counterparty_id   :integer
#  organization_id   :integer
#  description       :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  status            :integer
#  counterparty_type :string(255)
#  type              :string(255)
#  creator_id        :integer
#  updater_id        :integer
#  starts_at         :datetime
#  ends_at           :datetime
#  payment_terms     :string(255)
#

class CustomerAgreement < Agreement

  before_create :set_default_rule
  after_create :activate
  state_machine :status, initial: :draft do
    state :draft, value: STATUS_DRAFT
    state :active, value: STATUS_ACTIVE do
      validate ->(agr) { agr.check_rules }
    end

    state :canceled, value: STATUS_CANCELED

    event :cancel do
      transition :active => :canceled
    end

    event :activate do
      transition [:canceled, :draft] => :active
    end
  end

  scope :agreements_for, ->(customer) { where("agreements.counterparty_id = ?", customer.id) }


  private
  def set_default_rule
    rules << JobCharge.new(rate: 0, rate_type: :percentage)
  end
end
