class ServiceCallPaidEvent < ServiceCallEvent

  def init
    self.name         = I18n.t('service_call_paid_event.name')
    self.description  = I18n.t('service_call_paid_event.description')
    self.reference_id = 18
  end

  def process_event
    service_call.paid_customer
    super
  end

  def update_provider
    prov_service_call.paid_subcon
    prov_service_call.events << ServiceCallPaidEvent.new
  end

  def notification_recipients
    User.my_admins(service_call.organization.id)
  end

  def notification_class
    ScPaidNotification
  end

end