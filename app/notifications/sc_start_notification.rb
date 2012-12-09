class ScStartNotification < ServiceCallNotification
  def html_message
    I18n.t('notifications.sc_start_notification.html_message', technician: service_call.technician.try(:name), link: service_call_link).html_safe
  end

  def default_subject
    I18n.t('notifications.sc_start_notification.subject')
  end

  def default_content
    I18n.t('notifications.sc_start_notification.content', started_at: service_call.started_on, technician: service_call.technician.name)
  end

end