class ServiceCallDispatchedEvent < ServiceCallEvent

  def init
    self.name         = I18n.t('service_call_dispatched_event.name')
    self.description  = I18n.t('service_call_dispatched_event.description', subcontractor: service_call.subcontractor)
    self.reference_id = 16

  end

  def process_event
    service_call.start_subcon
    super
  end

  def update_provider
    prov_service_call.events << ServiceCallDispatchedEvent.new
  end

  def notification_recipients
    User.my_dispatchers(service_call.organization.id)
  end

  def notification_class
    ScDispatchedNotification
  end


end