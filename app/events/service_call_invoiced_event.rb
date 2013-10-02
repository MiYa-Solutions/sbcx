class ServiceCallInvoicedEvent < ServiceCallEvent

  def init
    self.name         = I18n.t('service_call_invoiced_event.name')
    self.description  = I18n.t('service_call_invoiced_event.description', subcontractor: service_call.subcontractor.name)
    self.reference_id = 100019

  end

  def process_event

    service_call.subcon_invoiced_payment(:state_only) if service_call.can_subcon_invoiced_payment?
    super
  end

  def update_provider
    prov_service_call.events << ServiceCallInvoicedEvent.new(triggering_event: self)
  end

  def notification_recipients
    User.my_admins(service_call.organization.id)
  end

  def notification_class
    ScInvoicedNotification
  end


end