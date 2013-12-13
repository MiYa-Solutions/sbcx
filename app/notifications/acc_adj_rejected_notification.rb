class AccAdjRejectedNotification < AdjustmentEntryNotification

  def html_message
    I18n.t('notifications.acc_adj_rejected_notification.html_message', link: 'change_me').html_safe
  end

  def default_subject
    I18n.t('notifications.acc_adj_rejected_notification.subject', ref: 'change_me')
  end

  def default_content
    I18n.t('notifications.acc_adj_rejected_notification.content', subcontractor: 'change_me')
  end

end