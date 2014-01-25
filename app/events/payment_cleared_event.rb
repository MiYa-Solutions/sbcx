class PaymentClearedEvent < Event

  def init
    self.name         = I18n.t('payment_cleared_event.name')
    self.description  = I18n.t('payment_cleared_event.description')
    self.reference_id = 300009
  end

  def process_event
  end

end
