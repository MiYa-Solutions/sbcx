class CollectionEntryObserver < ActiveRecord::Observer
  observe CollectedEntry.subclasses
  observe CollectionEntry.subclasses

  def before_deposit(entry, transition)
    entry.ticket.events << ScDepositEvent.new(amount: -entry.amount, entry_id: entry.id)
  end


  def before_deposited(entry, transition)
    entry.ticket.events << ScSubconDepositedEvent.new(amount: entry.amount, entry_id: entry.id) unless transition.args.first == :transition_only
  end

end