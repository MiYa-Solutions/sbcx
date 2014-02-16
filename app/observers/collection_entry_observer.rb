class CollectionEntryObserver < ActiveRecord::Observer
  def before_deposit(entry, transition)
    entry.ticket.events << ScDepositEvent.new(amount: entry.amount)
  end

end