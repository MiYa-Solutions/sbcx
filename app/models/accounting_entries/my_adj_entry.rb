require_relative 'adjustment_entry'
class MyAdjEntry < AdjustmentEntry

  after_create :create_event

  ##
  # State machines
  ##

  STATUS_SUBMITTED = 8000
  STATUS_ACCEPTED  = 8001
  STATUS_REJECTED  = 8002

  state_machine :status, initial: :submitted do
    state :rejected, value: STATUS_REJECTED
    state :accepted, value: STATUS_ACCEPTED
    state :submitted, value: STATUS_SUBMITTED

    event :accept do
      transition :submitted => :accepted
    end

    event :reject do
      transition :submitted => :rejected
    end

  end
  private
  def create_event
    self.account.events <<
        AccountAdjustmentEvent.new(entry_id: self.id.to_s) if account.accountable.member?
  end

end