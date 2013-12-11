# == Schema Information
#
# Table name: accounting_entries
#
#  id               :integer          not null, primary key
#  status           :integer
#  event_id         :integer
#  amount_cents     :integer          default(0), not null
#  amount_currency  :string(255)      default("USD"), not null
#  ticket_id        :integer
#  account_id       :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  type             :string(255)
#  description      :string(255)
#  balance_cents    :integer          default(0), not null
#  balance_currency :string(255)      default("USD"), not null
#

class AccountingEntry < ActiveRecord::Base
  monetize :amount_cents
  monetize :balance_cents

  validates_presence_of :account, :status, :type, :description
  validates_presence_of :event, :ticket, unless: ->(entry) { entry.instance_of?(MyAdjEntry) }
  validates_presence_of :agreement, unless: ->(entry) { entry.kind_of?(AdjustmentEntry) }

  belongs_to :account, autosave: true
  belongs_to :ticket
  belongs_to :event
  belongs_to :agreement

  before_create :set_amount_direction

  scope :by_account_and_datetime_range, ->(acc, range) { where(account_id: acc.id).where(created_at: range) }
  scope :by_account_and_ticket, ->(acc, ticket) { where(account_id: acc.id).where(ticket_id: ticket.id) }
  scope :by_acc, ->(acc) { where(account_id: acc.id) }


  # State machine  for ServiceCall status
  # first we will define the service call state values

  # common statuses for all accounting entrytypes
  # specific statuses will be setup in each sub-class by prefixing with an integer to avoid conflicts
  # i.e. STATUS_PENDING = 41 (4 being the subclass status identifier)

  STATUS_PENDING   = 0
  STATUS_DEPOSITED = 1
  STATUS_CLEARED   = 2

  state_machine :status, initial: :pending do
    state :pending, value: STATUS_PENDING
    state :cleared, value: STATUS_CLEARED
    state :deposited, value: STATUS_DEPOSITED

    after_failure do |service_call, transition|
      Rails.logger.debug { "AccountingEntry status state machine failure. Service Call errors : \n" + service_call.errors.messages.inspect + "\n The transition: " +transition.inspect }
    end

    event :deposit do
      transition :pending => :deposited
    end

    event :clear do
      transition [:pending, :deposited] => :cleared
    end

  end


  protected
  def set_amount_direction
    self.amount = self.amount * amount_direction
  end

  def amount_direction
    raise "The ammount direction is not defined - you need to define amount_direction method for #{self.class}"
  end

  private
  #def event_requirement
  #  @errors.add :event_id, "can't be blank" unless event_id.present? || self.kind_of?(AdjustmentEntry)
  #end

end

#Dir["#{Rails.root}/app/models/accounting_entries/*.rb"].each do |file|
#  require_dependency file
#end
