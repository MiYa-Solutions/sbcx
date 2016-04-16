class AffPaymentDepositEvent < EntryEvent

  def init
    self.name         = I18n.t('aff_entry_deposit_event.name')
    self.description  = I18n.t('aff_entry_deposit_event.description')
    self.reference_id = 300024

  end

  def process_event
    unless entry.matching_entry.nil?
      matching_ticket.events << AffPaymentDepositedEvent.new(triggering_event: self, entry_id: entry.matching_entry.id)
    end
  end

  def ticket
    @ticket ||= entry.ticket
  end

  def matching_ticket
    @matching_ticket ||= entry.matching_entry.ticket
  end

end
