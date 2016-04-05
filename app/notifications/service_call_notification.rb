class ServiceCallNotification < Notification
  def service_call
    @service_call ||= notifiable
  end

  def service_call_link
    link_to ServiceCall.model_name.human.downcase, url_helpers.service_call_path(service_call)
  end
end

if Rails.env == 'development'
  Dir["#{Rails.root}/app/notifications/*.rb"].each do |file|
    require_dependency file
  end
end
