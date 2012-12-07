class ServiceCallSettledEvent < ServiceCallEvent
  def init
    self.name         = I18n.t('service_call_settled_event.name')
    self.description  = I18n.t('service_call_settled_event.description')
    self.reference_id = 19
  end

  def update_provider
    prov_service_call.settled_on = service_call.settled_on
    prov_service_call.settle_subcon
    prov_service_call.events << ServiceCallSettledEvent.new
  end

  def notification_recipients
    User.my_admins(service_call.organization.id)
  end

  def notification_class
    ScSettledNotification
  end


end