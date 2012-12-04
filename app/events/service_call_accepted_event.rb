class ServiceCallAcceptedEvent < ServiceCallEvent
  def init
    self.name         = I18n.t('service_call_accepted_event.name')
    self.reference_id = 14
    self.description  = I18n.t('service_call_accepted_event.description', subcon_name: service_call.subcontractor.name)

  end

  def notification_recipients
    User.my_dispatchers(service_call.organization.id)
  end

  def notification_class
    ScAcceptedNotification
  end

  def update_provider
    prov_service_call = ServiceCall.find_by_ref_id_and_organization_id(service_call.ref_id, service_call.provider_id)

    prov_service_call.events << ServiceCallAcceptedEvent.new
    prov_service_call.accept_subcon

  end


end