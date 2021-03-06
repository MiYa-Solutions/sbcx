class ServiceCallCompleteEvent < ScCompletionEvent
  before_create :set_default_creator

  def init
    self.name         = I18n.t('service_call_complete_event.name')
    self.reference_id = 100005
    self.description  = I18n.t('service_call_complete_event.description', user: creator.name.rstrip)
  end

  def notification_class
    ScCompleteNotification
  end

  def update_provider
    prov_service_call.events << ServiceCallCompletedEvent.new(triggering_event: self)
  end

  def process_event
    if notify_provider?
      #copy_boms_to_provider
      ServiceCall.transaction do
        prov_service_call.system_update=true
        prov_service_call.tax          = service_call.tax
        prov_service_call.save!
        prov_service_call.system_update=false
      end
    end
    invoke_affiliate_billing
    service_call.update_status_provider if service_call.provider_entries.size > 0 && service_call.can_update_status_provider?
    service_call.update_status_subcon if service_call.subcon_entries.size > 0 && service_call.can_update_status_subcon?

    CustomerBillingService.new(self).execute if service_call.organization.my_customer?(service_call.customer)
    update_payment_status
    super
  end

end