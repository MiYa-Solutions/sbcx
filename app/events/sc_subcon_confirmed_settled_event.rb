class ScSubconConfirmedSettledEvent < ScSettlementEvent

  def init
    self.name         = I18n.t('service_call_subcon_confirmed_settled_event.name')
    self.description  = I18n.t('service_call_subcon_confirmed_settled_event.description', subcontractor: service_call.subcontractor.name)
    self.reference_id = 100035
  end

  def notification_class
    nil#ScSubconConfirmedSettledNotification
  end

  def update_provider
  end

  def process_event
    service_call.subcon_confirmed_subcon
    super
  end

end
