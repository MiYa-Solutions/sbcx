class ServiceCallStartEvent < Event
  def init
    self.name = I18n.t('service_call_start_event.name')

    self.reference_id = 6
  end

  # this is the event processed by the observer after the creation
  def process_event
    Rails.logger.debug { "Running ServiceCallDispatchEvent process" }
    service_call = associated_object

    # todo notify the technician in case it is not the submitting user
    if service_call.provider.subcontrax_member
      prov_service_call            = ServiceCall.find_by_ref_id_and_organization_id(service_call.ref_id, service_call.provider_id)
      prov_service_call.started_on = service_call.started_on
      prov_service_call.start_subcon
    end
    self.description = I18n.t('service_call_start_event.description', technician: service_call.technician.name)
    self.save


  end

end