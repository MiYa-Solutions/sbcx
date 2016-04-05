class AffPaymentDepositedNotification < AffiliatePaymentNotification

  def html_message
    I18n.t('notifications.aff_payment_confirmed_notification.html_message',
           affiliate: affiliate.name,
           type: entry.class.model_name.human,
           amount: humanized_money_with_symbol(event.amount),
           job_link:  ticket_link).html_safe
  end

  def default_subject
    I18n.t('notifications.aff_payment_confirmed_notification.subject', affiliate: affiliate.name)
  end

  def default_content
    I18n.t('notifications.aff_payment_confirmed_notification.content',
           affiliate: affiliate.name,
           type: entry.class.model_name.human,
           job_ref:  ticket_ref)
  end


end
