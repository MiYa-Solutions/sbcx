class CompletedServiceCallNotification < Notification
  def html_message
    service_call = notifiable
    link         = link_to ServiceCall.name.underscore.humanize.downcase, url_helpers.service_call_path(service_call)
    if service_call.class == TransferredServiceCall
      I18n.t('notifications.completed_service_call_notification.html_message', subcontractor: service_call.provider.name, link: link).html_safe
    else
      I18n.t('notifications.completed_notification.html_message', technician: service_call.technician.try(:name), link: link).html_safe
    end


  end

  def deliver
    NotificationMailer.completed_new_service_call(user, notifiable).deliver
  end
end