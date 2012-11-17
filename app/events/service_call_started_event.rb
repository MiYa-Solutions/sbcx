class ServiceCallStartedEvent < Event

  def init
    self.name         = I18n.t('service_call_started_event.name')
    self.reference_id = 17

  end

  def process_event

  end
end