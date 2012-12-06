class ServiceCallDispatchEvent < ServiceCallEvent
  def init
    self.name         = I18n.t('service_call_dispatch_event.name')
    self.description  = I18n.t('service_call_dispatch_event.description', technician: service_call.technician.name)
    self.reference_id = 5
  end


  def update_provider
    prov_service_call.events << ServiceCallDispatchedEvent.new
  end

  def notification_recipients
    user == service_call.technician ? nil : User.where(id: service_call.technician.id)
  end

  def notification_class
    ScDispatchNotification
  end

end