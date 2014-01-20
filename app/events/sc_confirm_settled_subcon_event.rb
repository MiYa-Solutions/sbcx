class ScConfirmSettledSubconEvent < ScSettlementEvent

  def init
    self.name         = I18n.t('service_call_subcon_confirm_settled_event.name')
    self.description  = I18n.t('service_call_subcon_confirm_settled_event.description')
    self.reference_id = 100033
  end

  def notification_recipients
    nil
  end

  def notification_class
    nil
  end

  def update_subcontractor
    subcon_service_call.events << ScProviderConfirmedSettledEvent.new(triggering_event: self)
  end

  def process_event
    clear_accounting_entries
    super
  end


end
