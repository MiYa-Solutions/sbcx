class ScProviderConfirmedSettledEvent < ScSettlementEvent

  def init
    self.name         = I18n.t('service_call_provider_confirmed_settled_event.name')
    self.description  = I18n.t('service_call_provider_confirmed_settled_event.description')
    self.reference_id = 100031
  end

  def notification_class
    ScProviderConfirmedSettledNotification
  end

  def process_event
    clear_accounting_entries
    service_call.provider_confirmed_provider
    super
  end

end
