class PaymentDepositedEvent < PaymentEvent

  def init
    self.name         = I18n.t('payment_deposited_event.name')
    self.description  = I18n.t('payment_deposited_event.description')
    self.reference_id = 300008
  end

  def process_event
    payment.deposit! if payment.can_deposit?
    ticket.deposited_payment! if ticket.can_deposited_payment?
  end

end
