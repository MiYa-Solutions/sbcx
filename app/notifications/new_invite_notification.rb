class NewInviteNotification < InviteNotification

  def html_message
    I18n.t('notifications.new_invite.html_message', org: notifiable.organization.name, link: invite_link).html_safe
  end

  def default_subject
    I18n.t('notifications.new_invite.subject', org: notifiable.organization.name)
  end

  def default_content
    I18n.t('notifications.new_invite.content', org: notifiable.organization.name)
  end

end