class ServiceCallStartEvent < ServiceCallEvent
  def init
    self.name         = I18n.t('service_call_start_event.name')
    self.description  = I18n.t('service_call_start_event.description', technician: service_call.technician.name)
    self.reference_id = 6
  end

  def notification_recipients
    User.my_dispatchers(service_call.organization.id)
  end

  def notification_class
    ScStartNotification
  end

  def update_provider
    prov_service_call.started_on = service_call.started_on
    prov_service_call.start_subcon

    prov_service_call.events << ServiceCallStartedEvent.new

  end


end