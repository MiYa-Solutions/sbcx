class ScDepositConfirmedEvent < ServiceCallEvent

  def init
    self.name         = I18n.t('service_call_deposit_confirmed_event.name')
    self.description  = I18n.t('service_call_deposit_confirmed_event.description', provider: service_call.provider.name)
    self.reference_id = 100026
  end

  def notification_recipients
    User.my_admins(service_call.organization_id)
  end

  def notification_class
    ScDepositConfirmedNotification
  end

  def process_event
    service_call.prov_confirmed_deposit_payment
    super
  end

end
