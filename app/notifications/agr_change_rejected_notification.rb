class AgrChangeRejectedNotification < AgreementNotification

  def html_message
    I18n.t('notifications.agreement.agr_change_rejected_notification.html_message', link: agreement_link, other_party: other_party.name).html_safe
  end

  def default_subject
    I18n.t('notifications.agreement.agr_change_rejected_notification.subject')
  end

  def default_content
    I18n.t('notifications.agreement.agr_change_rejected_notification.content', other_party: other_party.name, id: agreement.id)
  end

end