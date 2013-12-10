require_relative 'adjustment_entry'
class ReceivedAdjEntry < AdjustmentEntry


  ##
  # State machines
  ##

  STATUS_ACCEPTED = 8001
  STATUS_REJECTED = 8002

  state_machine :status, initial: :pending do
    state :rejected, value: STATUS_REJECTED
    state :accepted, value: STATUS_ACCEPTED
    state :pending, value: STATUS_PENDING

    event :accept do
      transition :pending => :accepted
    end

    event :reject do
      transition :pending => :rejected
    end

  end

  private

end