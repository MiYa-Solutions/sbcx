class ScProviderCanceledNotification < ServiceCallNotification

  def html_message
    I18n.t('notifications.sc_provider_canceled_notification.html_message', provider: service_call.provider.name, link: service_call_link).html_safe
  end

  def default_subject
    I18n.t('notifications.sc_provider_canceled_notification.subject', provider: service_call.provider.name, ref: service_call.ref_id)
  end

  def default_content
    I18n.t('notifications.sc_provider_canceled_notification.content', provider: service_call.provider.name, ref: service_call.ref_id, job_name: service_call.name)
  end


end
