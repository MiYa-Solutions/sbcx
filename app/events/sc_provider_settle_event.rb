class ScProviderSettleEvent < ScSettlementEvent

  def init
    self.name         = I18n.t('service_call_provider_settle_event.name')
    self.description  = I18n.t('service_call_provider_settle_event.description')
    self.reference_id = 100030
  end

  def notification_recipients
    nil
  end

  def notification_class
    nil
  end

  def update_provider
    prov_service_call.events << ScSubconSettledEvent.new(triggering_event: self, amount: amount, payment_type: payment_type)
  end

  def process_event
    update_affiliate_account(service_call.provider)
    super
  end


end
