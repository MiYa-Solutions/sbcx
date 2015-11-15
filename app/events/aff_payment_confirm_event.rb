class AffPaymentConfirmEvent < EntryEvent

  def init
    self.name         = I18n.t('aff_entry_confirm_event.name')
    self.description  = I18n.t('aff_entry_confirm_event.description')
    self.reference_id = 300020

  end

  def process_event
    ticket.confirm_settled_provider(amount: entry.amount)# if ticket.can_confirm_settled_provider?
    if entry.matching_entry
      entry.matching_entry.ticket.events << AffPaymentConfirmedEvent.new(triggering_event: self, entry_id: entry.matching_entry.id)
    end
  end

  def ticket
    @ticket || entry.ticket
  end

end
