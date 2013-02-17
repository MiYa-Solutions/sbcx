class ScSubconDepositedEvent < ServiceCallEvent

  def init

    self.name         = I18n.t('service_call_subcon_deposited_event.name')
    self.description  = I18n.t('service_call_subcon_deposited_event.description', subcontractor: service_call.subcontractor.name)
    self.reference_id = 100021

  end

  def notification_recipients
    User.my_admins(service_call.organization.id)
  end

  def notification_class
    ScSubconDepositedNotification
  end

  def update_provider
    nil
  end

  def process_event
    service_call.subcon_deposited_payment
    super
  end

end
