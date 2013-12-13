class AccAdjAcceptedNotification < AdjustmentEntryNotification

  def html_message
    I18n.t('notifications.acc_adj_accepted_notification.html_message', link: entry_link, affiliate: affiliate).html_safe
  end

  def default_subject
    I18n.t('notifications.acc_adj_accepted_notification.subject', affiliate: affiliate)
  end

  def default_content
    I18n.t('notifications.acc_adj_accepted_notification.content', affiliate: affiliate)
  end

end