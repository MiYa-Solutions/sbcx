class ServiceCallStartedEvent < ServiceCallEvent

  def init
    self.name         = I18n.t('service_call_started_event.name')
    self.name         = I18n.t('service_call_started_event.description', subcon_name: service_call.subcontractor.name)
    self.reference_id = 17

  end

  def update_provider
    prov_service_call.started_on = service_call.started_on
    prov_service_call.events << ServiceCallStartedEvent.new
    prov_service_call.start_subcon

  end

  def notification_recipients
    User.my_dispatchers(service_call.organization.id)
  end

  def notification_class
    ScStartedNotification
  end

end