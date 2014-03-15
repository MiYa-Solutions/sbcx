class EntryCancelEvent < EntryEvent

  def init
    self.name         = I18n.t('entry_cancel_event.name')
    self.description  = I18n.t('entry_cancel_event.description')
    self.reference_id = 300015
  end

  def process_event
    entry.ticket.events << EntryCanceledEvent.new(triggering_event: self, entry_id: entry.matching_entry.id)
  end

end
