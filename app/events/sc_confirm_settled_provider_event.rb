class ScConfirmSettledProviderEvent < ScSettlementEvent

  def init
    self.name         = I18n.t('service_call_provider_confirm_settled_event.name')
    self.description  = I18n.t('service_call_provider_confirmed_settled_event.description', provider: service_call.provider.name)
    self.reference_id = 100032
  end

  def notification_recipients
    nil
  end

  def notification_class
    nil
  end

  def update_provider
    prov_service_call.events << ScSubconConfirmedSettledEvent.new(triggering_event: self, amount: amount)
  end

  def process_event
    clear_accounting_entries
    super
  end

end
