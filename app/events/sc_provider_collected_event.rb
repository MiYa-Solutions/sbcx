class ScProviderCollectedEvent < ServiceCallEvent

  def init
    self.name         = I18n.t('service_call_provider_collected_event.name')
    self.description  = I18n.t('service_call_provider_collected_event.description', provider: service_call.provider.name)
    self.reference_id = 100027
  end

  def notification_recipients
    nil
  end

  def notification_class
    ScProviderCollectedNotification
  end

  def update_subcontractor
    subcon_service_call.events << ScProviderCollectedEvent.new(triggering_event: self) if subcon_service_call.allow_collection?
  end

  def process_event
    service_call.collector = service_call.provider
    service_call.provider_collected_payment
    super
  end


end
