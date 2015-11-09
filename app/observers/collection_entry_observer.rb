class CollectionEntryObserver < ActiveRecord::Observer
  observe [
              # Collection Entry Subclasses
              :cash_collection_from_subcon,
              :cheque_collection_from_subcon,
              :credit_card_collection_from_subcon,
              :amex_collection_from_subcon,

              #Collected Entry Subclasses
              :cash_collection_for_provider,
              :cheque_collection_for_provider,
              :credit_card_collection_for_provider,
              :amex_collection_for_provider,
              :cheque_collection_for_employer,

              :collected_entry,
              :collection_entry
          ]

  def after_deposit(entry, transition)
    entry.ticket.events << ScDepositEvent.new(amount: -entry.amount, entry_id: entry.id)
  end


  def after_deposited(entry, transition)
    entry.ticket.events << ScSubconDepositedEvent.new(entry_id: entry.id) unless transition.args.first == :transition_only
  end

end