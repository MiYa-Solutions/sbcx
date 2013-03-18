class ScCollectEvent < ServiceCallEvent

  def init
    self.name         = I18n.t('service_call_collect_event.name')
    self.description  = I18n.t('service_call_collect_event.description')
    self.reference_id = 100023
  end

  def notification_recipients
    nil
  end

  def notification_class
    nil
  end

  def update_provider
    prov_service_call.events << ScCollectedEvent.new(triggering_event: self)
  end

  def process_event
    set_customer_account_as_paid
    super
  end


end
