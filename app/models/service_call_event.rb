class ServiceCallEvent < Event
  def process_event

    Rails.logger.debug { "Running #{self.class.name} process_event method" }

    update_provider if notify_provider?

    notify notification_recipients, notification_class unless notification_recipients.nil?

  end

  def service_call
    @service_call ||= self.eventable
  end

  def notify_provider?
    service_call.provider.subcontrax_member? && service_call.provider.id != service_call.organization.id
  end

  def prov_service_call
    @prov_service_call ||= ServiceCall.find_by_ref_id_and_organization_id(service_call.ref_id, service_call.provider_id)
  end

end
