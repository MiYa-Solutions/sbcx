class CollectionEntryObserver < ActiveRecord::Observer
  observe [CollectedEntry.subclasses, CollectionEntry.subclasses, CollectedEntry, CollectionEntry]

  def after_deposit(entry, transition)
    entry.ticket.events << ScDepositEvent.new(amount: -entry.amount, entry_id: entry.id)
  end


  def after_deposited(entry, transition)
    entry.ticket.events << ScSubconDepositedEvent.new(entry_id: entry.id) unless transition.args.first == :transition_only
  end

end