class DepositEntryDisputedEvent < EntryEvent

  def init
    self.name         = I18n.t('entry_disputed_event.name')
    self.description  = I18n.t('entry_disputed_event.description')
    self.reference_id = 300012
  end

  def process_event
    entry.disputed!
    entry.ticket.deposit_disputed_prov_collection! if entry.ticket.can_deposit_disputed_prov_collection?

  end

end
