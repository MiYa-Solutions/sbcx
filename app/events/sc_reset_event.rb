class ScResetEvent < ServiceCallEvent

  def init
    self.name         = I18n.t('service_call_reset_event.name')
    self.description  = I18n.t('service_call_reset_event.description')
    self.reference_id = 100050
  end

  def notification_recipients
    nil
  end

  def notification_class
    nil
  end

  def process_event
    service_call.cancel_subcon
    service_call.reset_work
    super
  end


end
