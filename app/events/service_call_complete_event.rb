class ServiceCallCompleteEvent < ServiceCallEvent
  def init
    self.name         = I18n.t('service_call_complete_event.name')
    self.reference_id = 7
    self.description  = I18n.t('service_call_complete_event.description', technician: service_call.technician.name)
  end

  def notification_recipients
    User.my_dispatchers(service_call.organization.id)
  end

  def notification_class
    ScCompleteNotification
  end

  def update_provider
    prov_service_call = ServiceCall.find_by_ref_id_and_organization_id(service_call.ref_id, service_call.provider_id)

    prov_service_call.completed_on = service_call.completed_on
    prov_service_call.events << ServiceCallCompletedEvent.new
    prov_service_call.complete_subcon

  end

end