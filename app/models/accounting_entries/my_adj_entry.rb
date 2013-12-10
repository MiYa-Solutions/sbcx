require_relative 'adjustment_entry'
class MyAdjEntry < AdjustmentEntry

  after_create :invoke_event
  before_validation :set_initial_status

  ##
  # State machines
  ##

  STATUS_SUBMITTED = 8000
  STATUS_ACCEPTED  = 8001
  STATUS_REJECTED  = 8002

  state_machine :status do
    state :submitted, value: STATUS_SUBMITTED
    state :cleared, value: STATUS_CLEARED # reserved only when the affiliate is not a member
    state :rejected, value: STATUS_REJECTED
    state :accepted, value: STATUS_ACCEPTED

    event :accept do
      transition :submitted => :accepted
    end

    event :reject do
      transition :submitted => :rejected
    end

  end
  private
  def invoke_event
    self.account.events <<
        AccountAdjustmentEvent.new(entry_id: self.id.to_s) if account.accountable.member?
  end

  def set_initial_status
    self.status = account.accountable.member? ? STATUS_SUBMITTED : STATUS_CLEARED
  end

end