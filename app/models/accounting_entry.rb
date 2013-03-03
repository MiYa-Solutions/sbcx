# == Schema Information
#
# Table name: accounting_entries
#
#  id               :integer         not null, primary key
#  status           :integer
#  event_id         :integer
#  amount_cents     :integer         default(0), not null
#  amount_currency  :string(255)     default("USD"), not null
#  ticket_id        :integer
#  account_id       :integer
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#  type             :string(255)
#  description      :string(255)
#  balance_cents    :integer         default(0), not null
#  balance_currency :string(255)     default("USD"), not null
#

class AccountingEntry < ActiveRecord::Base
  monetize :amount_cents
  monetize :balance_cents

  validates_presence_of :account_id, :status, :event_id, :ticket_id, :type, :description

  belongs_to :account, autosave: true
  belongs_to :ticket
  belongs_to :event

  before_create :set_amount_direction

  scope :by_account_and_datetime_range, ->(acc, range) { where(account_id: acc.id).where(created_at: range) }


  # State machine  for ServiceCall status
  # first we will define the service call state values

  # common statuses for all service call types
  # specific statuses will be setup in each sub-class by prefixing with an integer to avoid conflicts
  # i.e. STATUS_SUBCLASS_STATUS = 41 (4 being the subclass status identifier)

  STATUS_PENDING    = 0
  STATUS_CLEARED    = 1
  STATUS_RECONCILED = 2

  state_machine :status, initial: :pending do
    state :pending, value: STATUS_PENDING
    state :cleared, value: STATUS_CLEARED
    state :reconciled, value: STATUS_RECONCILED

  end
  protected
  def set_amount_direction
    self.amount = self.amount * amount_direction
  end

  def amount_direction
    raise "The ammount direction is not defined - you need to define amount_direction method for #{self.class}"
  end
end
