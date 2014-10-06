class DepositEntryConfirmEvent < EntryEvent

  def init
    self.name         = I18n.t('entry_confirm_event.name')
    self.description  = I18n.t('entry_confirm_event.description')
    self.reference_id = 300013
  end

  def process_event
    clear_collection_entry
    entry.ticket.confirmed_subcon_collection if entry.ticket.can_confirmed_subcon_collection?
    unless entry.matching_entry.nil?
      entry.matching_entry.ticket.events << DepositEntryConfirmedEvent.new(triggering_event: self, entry_id: entry.matching_entry.id)
    end
  end

end
