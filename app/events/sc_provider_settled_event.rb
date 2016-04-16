class ScProviderSettledEvent < ScSettlementEvent

  def init
    self.name         = I18n.t('service_call_provider_settled_event.name')
    self.description  = I18n.t('service_call_provider_settled_event.description', provider: service_call.provider.name)
    self.reference_id = 100029
  end

  def notification_class
    ScProviderSettledNotification
  end

  def process_event
    service_call.prov_settle_type = payment_type
    service_call.prov_settle_amount = amount
    service_call.provider_marked_as_settled_provider
    update_affiliate_account(service_call.provider)
    super
  end


end
