class NewInviteNotification < Notification

  def html_message
    I18n.t('notifications.new_invite.html_message', org: notifiable.organization.name, link: link_to(notifiable)).html_safe
  end

  def default_subject
    I18n.t('notifications.new_invite.html_message', org: notifiable.organization.name)
  end

  def default_content
    I18n.t('notifications.new_invite.html_message', org: notifiable.organization.name)
  end

end