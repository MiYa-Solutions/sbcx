class ServiceCallReceivedEvent < Event
  def init
    self.name         = I18n.t('service_call_received_event.name')
    self.reference_id = 11
  end

  def process_event

  end

end