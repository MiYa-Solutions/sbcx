class ScSubconSettleEvent < ScSettlementEvent
  def init
    self.name         = I18n.t('service_call_subcon_settle_event.name')
    self.description  = I18n.t('service_call_subcon_settle_event.description')
    self.reference_id = 100013
  end

  def update_subcontractor
    subcon_service_call.events << ScProviderSettledEvent.new(triggering_event: self)
  end

  def notification_recipients
    nil
  end

  def notification_class
    nil
  end

  def process_event
    update_affiliate_account(service_call.subcontractor)
    super
  end

end