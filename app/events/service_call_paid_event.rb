class ServiceCallPaidEvent < ServiceCallEvent

  def init
    self.name         = I18n.t('service_call_paid_event.name')
    self.description  = I18n.t('service_call_paid_event.description')
    self.reference_id = 100009
  end


  def update_subcontractor
    subcon_service_call.events << ScProviderCollectedEvent.new(triggering_event: self) if subcon_service_call.allow_collection?
  end

  def notification_recipients
    User.my_admins(service_call.organization.id)
  end

  def notification_class
    ScPaidNotification
  end

end