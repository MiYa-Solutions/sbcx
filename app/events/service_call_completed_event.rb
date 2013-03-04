class ServiceCallCompletedEvent < ServiceCallEvent

  def init
    self.name         = I18n.t('service_call_completed_event.name')
    self.reference_id = 100006
    self.description  = I18n.t('service_call_completed_event.description', subcontractor: service_call.provider.name)
  end

  def process_event
    service_call.completed_on = self.triggering_event.service_call.completed_on
    service_call.complete_work
    super
    AffiliateBillingService.new(self).execute
  end

  def update_provider
    copy_boms_to_provider
    prov_service_call.events << ServiceCallCompletedEvent.new(triggering_event: self)
  end

  def notification_recipients
    User.my_dispatchers(service_call.organization.id)
  end

  def notification_class
    ScCompletedNotification
  end

end