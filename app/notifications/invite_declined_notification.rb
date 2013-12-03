class InviteDeclinedNotification < InviteNotification

  def html_message
    I18n.t('notifications.invite_declined.html_message', affiliate: invite.affiliate.name, link: invite_link).html_safe
  end

  def default_subject
    I18n.t('notifications.invite_declined.subject', affiliate: invite.affiliate.name)
  end

  def default_content
    I18n.t('notifications.invite_declined.content', affiliate: invite.affiliate.name)
  end

end