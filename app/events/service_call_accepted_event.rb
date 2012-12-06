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
    prov_service_call.events << ServiceCallAcceptedEvent.new
  end

  def process_event
    service_call.accept_subcon
    super
  end


end