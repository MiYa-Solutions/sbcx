class ServiceCallAcceptedEvent < Event
  def init
    self.name         = I18n.t('service_call_accepted_event.name')
    self.reference_id = 14
  end

  def process_event

  end

end