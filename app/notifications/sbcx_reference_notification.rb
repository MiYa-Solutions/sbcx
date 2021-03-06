class SbcxReferenceNotification < InviteNotification

  def html_message
    I18n.t('notifications.sbcx_reference_notification.html_message').html_safe
  end

  def default_subject
    I18n.t('notifications.sbcx_reference_notification.subject', org: notifiable.organization.name)
  end

  def default_content
    I18n.t('notifications.sbcx_reference_notification.content', org: notifiable.organization.name, message: notifiable.message)
  end

end