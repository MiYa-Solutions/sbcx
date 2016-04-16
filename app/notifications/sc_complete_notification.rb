class ScCompleteNotification < ServiceCallNotification
  def html_message
    I18n.t('notifications.sc_complete_notification.html_message', technician: service_call.technician.try(:name), link: service_call_link).html_safe
  end

  def default_subject
    I18n.t('notifications.sc_complete_notification.subject', ref: service_call.ref_id)
  end

  def default_content
    I18n.t('notifications.sc_complete_notification.content', technician: service_call.technician.try(:name), completed_at: service_call.completed_on)
  end

end