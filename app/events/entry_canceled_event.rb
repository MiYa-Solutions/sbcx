class EntryCanceledEvent < EntryEvent

  def init
    self.name         = I18n.t('entry_canceled_event.name')
    self.description  = I18n.t('entry_canceled_event.description')
    self.reference_id = 300016
  end

  def process_event
    entry.matching_entry.canceled!
  end

end
