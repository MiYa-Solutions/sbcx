class EntryDisputeEvent < EntryEvent

  def init
    self.name         = I18n.t('entry_dispute_event.name')
    self.description  = I18n.t('entry_dispute_event.description')
    self.reference_id = 300011
  end

  def process_event
    entry.matching_entry.ticket.events << EntryDisputedEvent.new(entry_id: entry.matching_entry.id, triggering_event: self)
  end

end
