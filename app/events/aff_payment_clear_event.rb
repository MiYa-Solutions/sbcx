class AffPaymentClearEvent < PaymentEvent

  def init
    self.name         = I18n.t('aff_payment_cleared_event.name')
    self.description  = I18n.t('aff_payment_cleared_event.description')
    self.reference_id = 300026
  end

  def process_event
    ticket.clear_provider! if ticket.can_clear_provider?
    unless entry.matching_entry.nil?
      entry.matching_entry.ticket.events << AffPaymentClearedEvent.new(triggering_event: self, entry_id: entry.matching_entry.id)
    end

  end

end
