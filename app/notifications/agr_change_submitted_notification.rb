class AgrChangeSubmittedNotification < AgreementNotification

  def html_message
    I18n.t('notifications.agreement.agr_change_submitted_notification.html_message', link: agreement_link, creator: agreement.updater.name).html_safe
  end

  def default_subject
    I18n.t('notifications.agreement.agr_change_submitted_notification.subject')
  end

  def default_content
    I18n.t('notifications.agreement.agr_change_submitted_notification.content', id: agreement.id)
  end

end