class ScPaymentRejectedEvent < ServiceCallEvent

  def init
    self.name         = I18n.t('sc_payment_rejected_event.name')
    self.description  = I18n.t('sc_payment_rejected_event.description')
    self.reference_id = 100044
  end

  def notification_recipients
    nil
  end

  def notification_class
    nil
  end

end
