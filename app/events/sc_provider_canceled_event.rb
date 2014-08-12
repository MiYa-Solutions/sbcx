class ScProviderCanceledEvent < ServiceCallEvent

  def init
    self.name         = I18n.t('service_call_provider_canceled_event.name')
    self.description  = I18n.t('service_call_provider_canceled_event.description', contractor: service_call.provider.name)
    self.reference_id = 100049
  end

  def notification_recipients
    User.my_dispatchers(service_call.organization.id).all
  end

  def notification_class
    ScProviderCanceledNotification
  end

  def update_subcontractor
    subcon_service_call.events << ScProviderCanceledEvent.new(triggering_event: self) unless subcon_service_call.canceled?
    subcon_service_call
  end

  def process_event
    service_call.cancel!(:state_only)
    service_call.cancel_prov_collection! if service_call.kind_of?(TransferredServiceCall) && service_call.can_cancel_prov_collection?
    service_call.cancel_provider! if service_call.kind_of?(TransferredServiceCall) && service_call.can_cancel_provider?
    service_call.cancel_subcon_collection! if defined?(service_call.can_cancel_subcon_collection?) && service_call.can_cancel_subcon_collection?
    service_call.cancel_subcon! if service_call.can_cancel_subcon?
    invoke_affiliate_billing
    super
  end


end
