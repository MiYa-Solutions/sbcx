class ServiceCallInvoicedEvent < ServiceCallEvent

  def init
    self.name         = I18n.t('service_call_invoiced_event.name')
    self.description  = I18n.t('service_call_invoiced_event.description', subcontractor: service_call.subcontractor.name)
    self.reference_id = 35

  end

  def process_event
    service_call.invoice_customer
    super
  end

  def update_provider
    copy_boms_to_provider
    prov_service_call.events << ServiceCallInvoicedEvent.new
  end

  def notification_recipients
    User.my_dispatchers(service_call.organization.id)
  end

  def notification_class
    ScInvoicedNotification
  end


end