class AffPaymentDepositedEvent < PaymentEvent

  def init
    self.name         = I18n.t('payment_deposited_event.name')
    self.description  = I18n.t('aff_payment_deposited_event.description')
    self.reference_id = 300017
  end

  def process_event
    ticket.deposited_subcon! if ticket.can_deposited_subcon?
    payment.deposited!(:state_only) if payment.can_deposited?
  end

end
