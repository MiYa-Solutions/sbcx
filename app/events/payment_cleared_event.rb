class PaymentClearedEvent < PaymentEvent

  def init
    self.name         = I18n.t('payment_cleared_event.name')
    self.description  = I18n.t('payment_cleared_event.description')
    self.reference_id = 300009
  end

  def process_event
    ticket.clear_payment! if ticket.can_clear_payment?
  end

end
