class ServiceCallRejectedEvent < ServiceCallEvent
  def init
    self.name         = I18n.t('service_call_rejected_event.name')
    self.description  = I18n.t('service_call_rejected_event.description', subcon_name: service_call.subcontractor.name)
    self.reference_id = 100012
  end

  def notification_class
    ScRejectedNotification
  end

  def update_provider
    prov_service_call.events << ServiceCallRejectedEvent.new(triggering_event: self)
  end

  def process_event
    service_call.reject_work(:state_only)
    super
  end
end