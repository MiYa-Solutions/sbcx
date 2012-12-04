class ServiceCallEvent < Event
  def process_event

    Rails.logger.debug { "Running #{self.class.name} process_event method" }

    update_provider if service_call.provider.subcontrax_member && service_call.provider.id != service_call.organization.id

    notify notification_recipients, notification_class unless notification_recipients.nil?

  end

  def service_call
    @service_call ||= self.eventable
  end

end
