class EntryConfirmEvent < EntryEvent

  def init
    self.name         = I18n.t('entry_confirm_event.name')
    self.description  = I18n.t('entry_confirm_event.description')
    self.reference_id = 300013
  end

  def process_event
    entry.ticket.events << EntryConfirmedEvent.new(triggering_event: self, entry_id: entry.matching_entry.id)
  end

end
