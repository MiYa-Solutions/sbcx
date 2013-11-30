class InviteDeclinedNotification < Notification

  def html_message
    I18n.t('notifications.invite_declined_notification.html_message', link: 'change_me').html_safe
  end

  def default_subject
    I18n.t('notifications.invite_declined_notification.subject', ref: 'change_me')
  end

  def default_content
    I18n.t('notifications.invite_declined_notification.content', subcontractor: 'change_me')
  end

end