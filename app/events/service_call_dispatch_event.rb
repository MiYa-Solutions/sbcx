class ServiceCallDispatchEvent < Event
  def init
    self.name         = I18n.t('service_call_dispatch_event.name')
    self.reference_id = 5
  end

  # this is the event processed by the observer after the creation
  def process_event
    Rails.logger.debug { "Running ServiceCallDispatchEvent process" }
    service_call      = associated_object

    # todo notify the technician in case it is not the submitting user

    prov_service_call = ServiceCall.find_by_ref_id_and_organization_id(service_call.ref_id, service_call.provider_id)
    prov_service_call.start_subcon

    prov_service_call.events << ServiceCallDispatchedEvent.new(description: I18n.t('service_call_dispatched_event.description', subcon_name: service_call.organization.name))


    #self.description =

  end

end