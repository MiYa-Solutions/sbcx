class AffPaymentRejectedNotification < AffiliatePaymentNotification

  def html_message
    I18n.t('notifications.aff_payment_rejected_notification.html_message',
           affiliate: affiliate.name,
           type: entry.class.model_name.human,
           amount: humanized_money_with_symbol(event.amount),
           job_link:  ticket_link).html_safe
  end

  def default_subject
    I18n.t('notifications.aff_payment_rejected_notification.subject')
  end

  def default_content
    I18n.t('notifications.aff_payment_rejected_notification.content',
           affiliate: affiliate.name,
           type: entry.class.model_name.human,
           amount: humanized_money_with_symbol(entry.amount))
  end


end
