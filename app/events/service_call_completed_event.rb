class ServiceCallCompletedEvent < ServiceCallEvent

  def init
    self.name         = I18n.t('service_call_completed_event.name')
    self.reference_id = 13
    self.description  = I18n.t('service_call_completed_event.description', subcontractor: service_call.provider.name)
  end

  def update_provider
    prov_service_call.completed_on = service_call.completed_on
    prov_service_call.events << ServiceCallCompletedEvent.new
    prov_service_call.complete_subcon

  end

  def notification_recipients
    User.my_dispatchers(service_call.organization.id)
  end

  def notification_class
    ScCompletedNotification
  end

end