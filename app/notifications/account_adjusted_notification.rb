class AccountAdjustedNotification < AdjustmentEntryNotification

  def html_message
    I18n.t('notifications.account_adjusted_notification.html_message', link: entry_link, affiliate: affiliate.name).html_safe
  end

  def default_subject
    I18n.t('notifications.account_adjusted_notification.subject', affiliate: affiliate.name)
  end

  def default_content
    I18n.t('notifications.account_adjusted_notification.content', affiliate: affiliate.name)
  end

end