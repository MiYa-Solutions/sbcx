class ServiceCallCompleteEvent < Event
  def init
    self.name = I18n.t('service_call_complete_event.name')

    self.reference_id = 7
  end

  # this is the event processed by the observer after the creation
  def process_event
    Rails.logger.debug { "Running ServiceCallDispatchEvent process" }
    service_call                   = associated_object

    # todo notify the technician in case it is not the submitting user

    prov_service_call              = ServiceCall.find_by_ref_id_and_organization_id(service_call.ref_id, service_call.provider_id)
    prov_service_call.completed_on = service_call.completed_on
    prov_service_call.events << ServiceCallCompletedEvent.new(description: I18n.t('service_call_completed_event.description'))
    prov_service_call.complete_subcon

    self.description = I18n.t('service_call_complete_event.description', technician: service_call.technician.name)


  end

end