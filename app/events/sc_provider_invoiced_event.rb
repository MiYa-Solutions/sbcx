class ScProviderInvoicedEvent < ServiceCallEvent

  def init
    self.name         = I18n.t('service_call_provider_invoiced_event.name')
    self.description  = I18n.t('service_call_provider_invoiced_event.description', provider: service_call.provider.name)
    self.reference_id = 100020
  end

  def notification_recipients
    User.my_admins(service_call.organization_id)
  end

  def notification_class
    ScProviderInvoicedNotification
  end

  def process_event
    service_call.provider_invoiced_payment
    super
  end

  def update_subcontractor
    subcon_service_call.events << ScProviderInvoicedEvent.new(triggering_event: self)
  end


end
