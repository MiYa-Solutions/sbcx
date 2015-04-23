class ScWorkReopenEvent < ServiceCallEvent

  def init
    self.name         = I18n.t('service_call_work_reopen_event.name')
    self.description  = I18n.t('service_call_work_reopen_event.description')
    self.reference_id = 100052
  end

  def notification_recipients
    nil
  end

  def notification_class
    ScWorkReopenNotification
  end

  def update_provider
  end

  def process_event
    service_call.process_reopen_event(self)
  end


end
