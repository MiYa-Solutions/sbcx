class DepositEntryObserver < ActiveRecord::Observer
  def before_confirm(entry, transition)
    entry.ticket.events << EntryConfirmEvent.new(entry_id: entry.id)
  end

  def before_dispute(entry, transition)
    entry.ticket.events << EntryDisputeEvent.new(entry_id: entry.id)
  end

  def before_cancel(entry, transition)
    entry.ticket.events << EntryCancelEvent.new(entry_id: entry.id)
  end
end