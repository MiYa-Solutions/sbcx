class AccAdjCanceledNotification < AdjustmentEntryNotification

  def html_message
    I18n.t('notifications.acc_adj_canceled_notification.html_message', link: entry_link, affiliate: affiliate.name).html_safe
  end

  def default_subject
    I18n.t('notifications.acc_adj_canceled_notification.subject', affiliate: affiliate.name)
  end

  def default_content
    I18n.t('notifications.acc_adj_canceled_notification.content', affiliate: affiliate.name)
  end

end