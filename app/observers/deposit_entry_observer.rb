class DepositEntryObserver < ActiveRecord::Observer
  def after_confirm(entry, transition)
    entry.ticket.events << DepositEntryConfirmEvent.new(entry_id: entry.id)
  end

  def before_dispute(entry, transition)
    entry.ticket.events << DepositEntryDisputeEvent.new(entry_id: entry.id)
  end
end