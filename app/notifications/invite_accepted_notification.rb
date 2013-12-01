class InviteAcceptedNotification < InviteNotification

  def html_message
    I18n.t('notifications.invite_accepted.html_message', affilaite: notifiable.affiliate.name, link: invite_link).html_safe
  end

  def default_subject
    I18n.t('notifications.invite_accepted.subject', affiliate: notifiable.affiliate.name)
  end

  def default_content
    I18n.t('notifications.invite_accepted.content', affiliate: notifiable.affiliate.name)
  end

end