class ScClearCustomerPaymentEvent < ServiceCallEvent

  def init
    self.name         = I18n.t('service_call_clear_customer_payment_event.name')
    self.description  = I18n.t('service_call_clear_customer_payment_event.description')
    self.reference_id = 100034
  end

  def notification_recipients
    nil
  end

  def notification_class
    nil
  end

end
