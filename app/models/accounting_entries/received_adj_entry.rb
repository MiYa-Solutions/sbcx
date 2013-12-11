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

    ###
    ## actions to take place after transitions
    ###
    #after_transition :pending => :accepted do |entry|
    #  invoke_accepted_event(entry)
    #end

    #def invoke_accepted_event(entry)
    #  entry.account.events << AccAdjAcceptEvent.new(entry_id: entry.id)
    #end

  end

  private


end