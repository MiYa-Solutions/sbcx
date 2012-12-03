class ScReceivedNotification < ServiceCallNotification

  def html_message

    I18n.t('notifications.received_service_call_notification.html_message', prov_name: service_call.provider.name, link: service_call_link).html_safe

  end

  def default_subject
    I18n.t('notification_mailer.received_new_service_call.subject', provider: service_call.provider.name)
  end

  def default_content
    I18n.t('notification_mailer.received_new_service_call.content', provider: service_call.provider.name, ref: service_call.ref_id)
  end

end