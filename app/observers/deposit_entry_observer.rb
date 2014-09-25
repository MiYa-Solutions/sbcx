class DepositEntryObserver < ActiveRecord::Observer
  def after_confirm(entry, transition)
    entry.ticket.events << DepositEntryConfirmEvent.new(entry_id: entry.id)
  end

  def after_confirmed(entry, transition)
    entry.ticket.events << DepositEntryConfirmedEvent.new(entry_id: entry.id) unless transition.args.first == :state_only
  end

  def before_dispute(entry, transition)
    entry.ticket.events << DepositEntryDisputeEvent.new(entry_id: entry.id)
  end

  def after_disputed(entry, transition)
    entry.ticket.events << DepositEntryDisputedEvent.new(entry_id: entry.id)
  end
end