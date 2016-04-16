class ScSubconSettledEvent < ScSettlementEvent
  def init
    self.name         = I18n.t('service_call_subcon_settled_event.name')
    self.description  = I18n.t('service_call_subcon_settled_event.description', subcontractor: service_call.subcontractor.name)
    self.reference_id = 100014
  end

  def notification_class
    ScSubconSettledNotification
  end

  def process_event
    service_call.settled_on = self.triggering_event.service_call.settled_on if self.triggering_event.present?
    service_call.subcon_settle_type = payment_type
    service_call.subcon_settle_amount = amount
    service_call.subcon_marked_as_settled_subcon(:state_only)
    update_affiliate_account(service_call.subcontractor)
    super
  end


end