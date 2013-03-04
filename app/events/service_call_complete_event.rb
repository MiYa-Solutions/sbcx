class ServiceCallCompleteEvent < ServiceCallEvent
  before_create :set_default_creator
  def init
    self.name         = I18n.t('service_call_complete_event.name')
    self.reference_id = 100005
    self.description  = I18n.t('service_call_complete_event.description', user: creator.name.rstrip)
  end

  def notification_recipients
    User.my_dispatchers(service_call.organization.id)
  end

  def notification_class
    ScCompleteNotification
  end

  def update_provider
    prov_service_call.events << ServiceCallCompletedEvent.new(triggering_event: self)
  end

  def process_event
    copy_boms_to_provider if notify_provider?
    AffiliateBillingService.new(self).execute if service_call.subcontractor.present?
    CustomerBillingService.new(self).execute
    super
  end

end