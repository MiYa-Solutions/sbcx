class MyAdjEntryObserver < ActiveRecord::Observer
  def after_cancel(entry, transition)
    entry.account.events << AccAdjCancelEvent.new(entry_id: entry.id)
  end
end