class ServiceCallInvoiceEvent < ServiceCallEvent

  def init
    self.name         = I18n.t('service_call_invoice_event.name')
    self.description  = I18n.t('service_call_invoice_event.description')
    self.reference_id = 100018
  end

  def update_provider
    prov_service_call.events << ServiceCallInvoicedEvent.new(triggering_event: self)
  end

  def update_subcontractor
    subcon_service_call.events << ScProviderInvoicedEvent.new(triggering_event: self) if subcon_service_call.present?
  end

  def notification_recipients
    nil
  end

  def notification_class
    nil
  end

end