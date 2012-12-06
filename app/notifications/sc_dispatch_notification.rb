class ScDispatchNotification < ServiceCallNotification
  def html_message
    I18n.t('notifications.sc_dispatch_notification.html_message', technician: service_call.technician.try(:name), link: service_call_link).html_safe
  end

  def default_subject
    I18n.t('notifications.sc_dispatch_notification.subject')
  end

  def default_content
    I18n.t('notifications.sc_dispatch_notification.content', ref: service_call.ref_id)
  end

end