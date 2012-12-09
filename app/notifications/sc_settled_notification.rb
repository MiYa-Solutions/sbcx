class ScSettledNotification < ServiceCallNotification
  def html_message
    I18n.t('notifications.sc_settled_notification.html_message', customer: service_call.customer.name, link: service_call_link).html_safe
  end

  def default_subject
    I18n.t('notifications.sc_settled_notification.subject', ref: service_call.ref_id)
  end

  def default_content
    I18n.t('notifications.sc_settled_notification.content', subcontractor: service_call.subcontractor.name, ref: service_call.ref_id)
  end

end