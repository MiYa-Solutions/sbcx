class ServiceCallSettleEvent < Event
  def init
    self.name        = I18n.t('service_call_settle_event.name')
    self.description = I18n.t('service_call_settle_event.description')

    self.reference_id = 8
  end

  # this is the event processed by the observer after the creation
  def process_event
    Rails.logger.debug { "Running ServiceCallDispatchEvent process" }
    service_call                 = associated_object

    # todo notify the technician in case it is not the submitting user

    prov_service_call            = ServiceCall.find_by_ref_id_and_organization_id(service_call.ref_id, service_call.provider_id)
    prov_service_call.settled_on = service_call.settled_on
    prov_service_call.settle_subcon


  end

end