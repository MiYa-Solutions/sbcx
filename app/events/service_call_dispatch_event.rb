class ServiceCallDispatchEvent < ServiceCallEvent
  def init
    self.name         = I18n.t('service_call_dispatch_event.name')
    if service_call.technician.nil?
      self.description = I18n.t('service_call_dispatch_event.description', technician: '')
    else
      self.description = I18n.t('service_call_dispatch_event.description', technician: service_call.technician.name)
    end
    self.reference_id = 100007
  end


  def update_provider
    prov_service_call.events << ServiceCallStartedEvent.new(triggering_event: self)
  end

  def notification_recipients
    user == service_call.technician ? nil : User.where(id: service_call.technician.id)
  end

  def notification_class
    ScDispatchNotification
  end

end