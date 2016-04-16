class ScCancelNotification < ServiceCallNotification
  def html_message
    customer_link = link_to(service_call.customer.name, url_helpers.customer_path(service_call.customer)).html_safe
    I18n.t('notifications.sc_cancel_notification.html_message', customer: customer_link, link: service_call_link).html_safe
  end

  def default_subject
    I18n.t('notifications.sc_cancel_notification.subject', ref: service_call.ref_id)
  end

  def default_content
    I18n.t('notifications.sc_cancel_notification.content', customer: service_call.customer.name, ref: service_call.ref_id)
  end

end