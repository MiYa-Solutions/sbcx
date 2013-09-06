class AgrSubconAcceptedNotification < AgreementNotification

  def html_message
    I18n.t('notifications.agr_subcon_accepted_notification.html_message', name: agreement.name, link: agreement_link, other_party: other_party).html_safe
  end

  def default_subject
    I18n.t('notifications.agr_subcon_accepted_notification.subject')
  end

  def default_content
    I18n.t('notifications.agr_subcon_accepted_notification.content', name: agreement.name, other_party: other_party)
  end


end
