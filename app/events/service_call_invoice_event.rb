class ServiceCallInvoiceEvent < ServiceCallEvent

  def init
    self.name         = I18n.t('service_call_invoice_event.name')
    self.description  = I18n.t('service_call_invoice_event.description')
    self.reference_id = 20
  end

  def update_provider
    copy_boms_to_provider
    prov_service_call.events << ServiceCallInvoicedEvent.new
  end

  def notification_recipients
    nil
  end

  def notification_class
    nil
  end

end