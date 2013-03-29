class ServiceCallNotification < Notification
  def service_call
    @service_call ||= notifiable
  end

  def service_call_link
    link_to ServiceCall.model_name.human.downcase, url_helpers.service_call_path(service_call)
  end
end
