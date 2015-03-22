class ScCancelTransferEvent < ServiceCallEvent

  def init
    self.name         = I18n.t('service_call_cancel_transfer_event.name')
    self.description  = I18n.t('service_call_cancel_transfer_event.description', subcontractor: service_call.subcontractor.name)
    self.reference_id = 100051
  end

  def notification_recipients
    nil
  end

  def notification_class
    nil
  end

  def update_subcontractor
    unless subcon_service_call.rejected?
      subcon_service_call.events << ScProviderCanceledEvent.new(triggering_event: self) unless subcon_service_call.canceled?
    end
    subcon_service_call
  end

  def process_event
    service_call.reset_work!
    service_call.cancel_subcon_collection! if defined?(service_call.can_cancel_subcon_collection?) && service_call.can_cancel_subcon_collection?
    service_call.cancel_subcon! if service_call.can_cancel_subcon?
    invoke_affiliate_billing
    super
  end
end
