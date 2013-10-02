class ServiceCallCompletedEvent < ScCompletionEvent

  def init
    self.name         = I18n.t('service_call_completed_event.name')
    self.reference_id = 100006
    self.description  = I18n.t('service_call_completed_event.description', subcontractor: service_call.subcontractor.name)
  end

  def process_event
    service_call.completed_on = self.triggering_event.service_call.completed_on
    service_call.complete_work(:state_only)
    super
    invoke_affiliate_billing
    CustomerBillingService.new(self).execute if service_call.organization.my_customer?(service_call.customer)
  end

  def update_provider
    if notify_provider?
      copy_boms_to_provider
      prov_service_call.tax = service_call.tax
      prov_service_call.save!
    end

    prov_service_call.events << ServiceCallCompletedEvent.new(triggering_event: self)
  end

  def notification_recipients
    User.my_dispatchers(service_call.organization.id)
  end

  def notification_class
    ScCompletedNotification
  end

end