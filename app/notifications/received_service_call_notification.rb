class ReceivedServiceCallNotification < Notification
  def html_message
    service_call = notifiable
    link         = link_to ServiceCall.name.underscore.humanize.downcase, url_helpers.service_call_path(service_call)
    I18n.t('notifications.received_service_call_notification.html_message', prov_name: service_call.provider.name, link: link).html_safe

  end

  def deliver
    NotificationMailer.received_new_service_call(user, notifiable).deliver
  end
end