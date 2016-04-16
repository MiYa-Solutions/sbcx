class ReceivedAdjEntryObserver < ActiveRecord::Observer
  def after_accept(entry, transition)
    entry.account.events << AccAdjAcceptEvent.new(entry_id: entry.id)
  end

  def after_reject(entry, transition)
    entry.account.events << AccAdjRejectEvent.new(entry_id: entry.id)
  end
end