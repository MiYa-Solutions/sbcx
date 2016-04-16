class ScAcceptedNotification < ServiceCallNotification
  def html_message
    I18n.t('notifications.sc_accepted_notification.html_message', subcontractor: service_call.subcontractor.name, link: service_call_link).html_safe
  end

  def default_subject
    I18n.t('notifications.sc_accepted_notification.subject', ref: service_call.ref_id)
  end

  def default_content
    I18n.t('notifications.sc_accepted_notification.content', subcontractor: service_call.subcontractor.name)
  end

end