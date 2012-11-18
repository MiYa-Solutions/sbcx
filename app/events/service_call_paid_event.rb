class ServiceCallPaidEvent < Event

  def init
    self.name         = I18n.t('service_call_paid_event.name')
    self.reference_id = 18
  end

  def process_event

    Rails.logger.debug { "Running ServiceCallPaidEvent process" }
    service_call = associated_object
    service_call.paid_customer
    # todo notify the technician in case it is not the submitting user

    prov_service_call = ServiceCall.find_by_ref_id_and_organization_id(service_call.ref_id, service_call.provider_id)
    unless service_call.id == prov_service_call.id
      prov_service_call.paid_subcon
      prov_service_call.events << ServiceCallPaidEvent.new(description: I18n.t('service_call_paid_event.description'))
    end


  end

end