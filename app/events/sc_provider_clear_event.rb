class ScProviderClearEvent < ScSettlementEvent

  def init
    self.name         = I18n.t('service_call_provider_clear_event.name')
    self.description  = I18n.t('service_call_provider_clear_event.description', prov: service_call.provider.name, job_ref: service_call.ref_id)
    self.reference_id = 100039
  end

  def notification_recipients
    nil
  end

  def notification_class
    nil
  end

  def update_provider
    prov_service_call.events << ScSubconClearedEvent.new(triggering_event: self)
  end

  # def process_event
  #   clear_accounting_entries
  #   super
  # end


end
