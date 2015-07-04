class AffPaymentDisputeEvent < EntryEvent

  def init
    self.name         = I18n.t('aff_entry_dispute_event.name')
    self.description  = I18n.t('aff_entry_dispute_event.description')
    self.reference_id = 300022

  end

  def process_event
    ticket.dispute_provider(amount: entry.amount)
    unless entry.matching_entry.nil?
      entry.matching_entry.ticket.events << AffPaymentDisputedEvent.new(triggering_event: self, entry_id: entry.matching_entry.id)
    end
  end

  def ticket
    @ticket || entry.ticket
  end

end
