class ScSubconSettledEvent < ScSettlementEvent
  def init
    self.name         = I18n.t('service_call_subcon_settled_event.name')
    self.description  = I18n.t('service_call_subcon_settled_event.description')
    self.reference_id = 100014
  end

  def notification_recipients
    User.my_admins(service_call.organization.id)
  end

  def notification_class
    ScSubconSettledNotification
  end

  def process_event
    service_call.settled_on = self.triggering_event.service_call.settled_on if self.triggering_event.present?
    service_call.subcon_payment = self.triggering_event.service_call.provider_payment if self.triggering_event.present?
    service_call.subcon_marked_as_settled_subcon
    update_affiliate_account
    super
  end


end