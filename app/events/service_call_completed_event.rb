class ServiceCallCompletedEvent < Event

  def init
    self.name         = I18n.t('service_call_completed_event.name')
    self.reference_id = 13
  end

  def process_event

  end

end