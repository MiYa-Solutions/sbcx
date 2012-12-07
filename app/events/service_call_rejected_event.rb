class ServiceCallRejectedEvent < ServiceCallEvent
  def init
    self.name         = I18n.t('service_call_rejected_event.name')
    self.description  = I18n.t('service_call_rejected_event.description', subcon_name: service_call.subcontractor.name)
    self.reference_id = 12
  end

  def notification_recipients
    User.my_dispatchers(service_call.organization.id)
  end

  def notification_class
    ScRejectedNotification
  end

  def update_provider
    prov_service_call.events << ServiceCallRejectedEvent.new
  end

  def process_event
    service_call.reject_subcon
    super
  end
end