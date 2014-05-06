class DepositEntryConfirmedEvent < EntryEvent

  def init
    self.name         = I18n.t('entry_confirmed_event.name')
    self.description  = I18n.t('entry_confirmed_event.description')
    self.reference_id = 300014
  end

  def process_event
    entry.confirmed!
    entry.ticket.confirmed_prov_collection! if entry.ticket.can_confirmed_prov_collection?
  end

end
