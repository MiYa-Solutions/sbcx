class ScProviderSettledEvent < ScSettlementEvent

  def init
    self.name         = I18n.t('service_call_provider_settled_event.name')
    self.description  = I18n.t('service_call_provider_settled_event.description', provider: service_call.provider.name)
    self.reference_id = 100029
  end

  def notification_recipients
    User.my_admins(service_call.organization_id)
  end

  def notification_class
    ScProviderSettledNotification
  end

  def process_event
    service_call.provider_payment = self.triggering_event.service_call.subcon_payment if self.triggering_event.present?
    service_call.payment_type = self.triggering_event.service_call.payment_type if self.triggering_event.present?
    service_call.provider_marked_as_settled_provider
    update_affiliate_account
    super
  end


end
