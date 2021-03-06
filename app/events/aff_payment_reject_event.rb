class AffPaymentRejectEvent < RejectionEvent

  def init
    self.name         = I18n.t('aff_payment_reject_event.name')
    self.description  = I18n.t('aff_payment_reject_event.description', payment_id: payment.id, payment_type: payment.name)
    self.reference_id = 300025
  end

  def process_event
    update_affiliate_status
    update_account_balance
    unless entry.matching_entry.nil?
      entry.matching_entry.ticket.events << AffPaymentRejectedEvent.new(triggering_event: self, entry_id: entry.matching_entry.id)
    end
  end

  private

  def update_affiliate_status
    ticket.reject_provider
  end



end
