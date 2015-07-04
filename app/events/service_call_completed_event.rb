class ServiceCallCompletedEvent < ScCompletionEvent

  def init
    self.name         = I18n.t('service_call_completed_event.name')
    self.reference_id = 100006
    self.description  = I18n.t('service_call_completed_event.description', subcontractor: service_call.subcontractor.name)
  end

  def process_event
    service_call.completed_on = self.triggering_event.service_call.completed_on
    service_call.complete_work!(:state_only)
    super
    invoke_affiliate_billing
    service_call.update_status_provider if service_call.provider_entries.size > 0 && service_call.can_update_status_provider?
    service_call.update_status_subcon if service_call.subcon_entries.size > 0 && service_call.can_update_status_subcon?
    CustomerBillingService.new(self).execute if service_call.organization.my_customer?(service_call.customer)
    update_payment_status
  end

  def update_provider
    if notify_provider?
      #copy_boms_to_provider
      prov_service_call.update_attribute(:tax, service_call.tax)
      prov_service_call.save!
    end

    prov_service_call.events << ServiceCallCompletedEvent.new(triggering_event: self)
  end

  def notification_class
    ScCompletedNotification
  end

end