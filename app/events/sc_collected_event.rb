class ScCollectedEvent < ServiceCallEvent

  def init
    self.name         = I18n.t('service_call_collected_event.name')
    self.description  = I18n.t('service_call_collected_event.description', subcontractor: service_call.subcontractor.name)
    self.reference_id = 100024
  end

  def notification_recipients
    User.my_admins(service_call.organization_id)
  end

  def notification_class
    ScCollectedNotification
  end

  def update_provider
    nil
  end

  def process_event
    service_call.collector = service_call.subcontractor
    service_call.subcon_collected_payment
    super
  end


end
