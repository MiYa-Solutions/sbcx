class ServiceCallDispatchedEvent < ServiceCallEvent

  def init
    self.name         = I18n.t('service_call_dispatched_event.name')
    self.description  = I18n.t('service_call_dispatched_event.description', subcontractor: service_call.subcontractor.name)
    self.reference_id = 100008

  end

  def process_event
    service_call.started_on    = self.triggering_event.service_call.started_on
    service_call.technician_id = self.triggering_event.service_call.technician_id
    service_call.start_work
    super
  end

  def update_provider
    prov_service_call.events << ServiceCallDispatchedEvent.new
  end

  def notification_class
    ScDispatchedNotification
  end


end