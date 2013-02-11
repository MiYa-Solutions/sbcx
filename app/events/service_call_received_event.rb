class ServiceCallReceivedEvent < ServiceCallEvent
  def init
    self.name         = I18n.t('service_call_received_event.name')
    self.reference_id = 100010
  end

  def notification_recipients
    User.my_dispatchers(service_call.organization.id)
  end

  def notification_class
    ScReceivedNotification
  end

  def update_provider
    # no need to update the provider for this event
  end

end