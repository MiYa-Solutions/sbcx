#require 'adjustment_entry'
class ReceivedAdjEntry < AdjustmentEntry


  ##
  # State machines
  ##

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

  def allowed_status_events
    self.status_events & [:accept, :reject]
  end


  private


end