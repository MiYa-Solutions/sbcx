class ServiceCallDispatchedEvent < Event

  def init
    self.name         = I18n.t('service_call_dispatched_event.name')
    self.reference_id = 16

  end

  def process_event

  end

end