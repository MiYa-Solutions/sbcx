class AffPaymentDepositEvent < EntryEvent

  def init
    self.name         = I18n.t('aff_entry_deposit_event.name')
    self.description  = I18n.t('aff_entry_deposit_event.description')
    self.reference_id = 300024

  end

  def process_event
    unless entry.matching_entry.nil?
      entry.matching_entry.events << AffPaymentDepositedEvent.new(triggering_event: self, entry_id: entry.matching_entry.id)
    end
  end

  def ticket
    @ticket || entry.ticket
  end

end
