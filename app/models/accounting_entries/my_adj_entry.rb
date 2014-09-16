# == Schema Information
#
# Table name: accounting_entries
#
#  id                :integer          not null, primary key
#  status            :integer
#  event_id          :integer
#  amount_cents      :integer          default(0), not null
#  amount_currency   :string(255)      default("USD"), not null
#  ticket_id         :integer
#  account_id        :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  type              :string(255)
#  description       :string(255)
#  balance_cents     :integer          default(0), not null
#  balance_currency  :string(255)      default("USD"), not null
#  agreement_id      :integer
#  external_ref      :string(255)
#  collector_id      :integer
#  collector_type    :string(255)
#  matching_entry_id :integer
#

#require 'adjustment_entry'
class MyAdjEntry < AdjustmentEntry

  after_create :invoke_event
  before_create :set_initial_status

  ##
  # State machines
  ##


  state_machine :status do
    state :submitted, value: STATUS_SUBMITTED
    state :cleared, value: STATUS_CLEARED # reserved only when the affiliate is not a member
    state :rejected, value: STATUS_REJECTED
    state :accepted, value: STATUS_ACCEPTED

    event :accept do
      transition [:submitted, :rejected] => :accepted
    end

    event :reject do
      transition :submitted => :rejected
    end

  end

  def allowed_status_events
    self.status_events & [:cancel]
  end

  private
  def invoke_event
    if account.accountable_type == 'Organization'
      self.account.events <<
          AccountAdjustmentEvent.new(entry_id: self.id.to_s) if account.accountable.member?
    end
  end

  def set_initial_status
    case account.accountable_type
      when 'Organization'
        self.status = account.accountable.member? ? STATUS_SUBMITTED : STATUS_CLEARED
      when 'Customer'
        self.status = STATUS_CLEARED
      else
        raise "Unrecognized accountable type '#{account.accountable_type}'"
    end

  end

end
