class PaymentRejectedEvent < Event

  def init
    self.name         = I18n.t('payment_rejected_event.name')
    self.description  = I18n.t('payment_rejected_event.description')
    self.reference_id = 300010
  end

  def process_event
  end

end
