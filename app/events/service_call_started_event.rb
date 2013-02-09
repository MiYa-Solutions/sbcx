class ServiceCallStartedEvent < ServiceCallEvent

  def init
    self.name         = I18n.t('service_call_started_event.name')
    self.name         = I18n.t('service_call_started_event.description', subcon_name: service_call.subcontractor.name)
    self.reference_id = 100016

  end

  def update_provider
    prov_service_call.events << ServiceCallStartedEvent.new(triggering_event: self)
  end

  def notification_recipients
    User.my_dispatchers(service_call.organization.id)
  end

  def notification_class
    ScStartedNotification
  end

  def process_event
    service_call.started_on = self.triggering_event.service_call.started_on
    if service_call.can_start_work?
      service_call.start_work
    else
      service_call.save!
    end
    super
  end

end