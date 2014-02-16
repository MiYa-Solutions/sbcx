class EntryDisputedEvent < EntryEvent

  def init
    self.name         = I18n.t('entry_disputed_event.name')
    self.description  = I18n.t('entry_disputed_event.description')
    self.reference_id = 300012
  end

  def process_event
    entry.matching_entry.disputed!
  end

end
