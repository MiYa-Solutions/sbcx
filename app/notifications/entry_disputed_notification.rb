class EntryDisputedNotification < AdjustmentEntryNotification

  def html_message
    I18n.t('notifications.entry_disputed_notification.html_message', link: entry_link, affiliate: affiliate.name).html_safe
  end

  def default_subject
    I18n.t('notifications.entry_disputed_notification.subject', affiliate: affiliate.name, ref: entry.ticket.ref_id)
  end

  def default_content
    I18n.t('notifications.entry_disputed_notification.content', affiliate: affiliate.name, ref: entry.ticket.ref_id)
  end

end