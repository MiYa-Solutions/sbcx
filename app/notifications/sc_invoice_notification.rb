class ScInvoiceNotification < CustomerNotification
  def html_message
    I18n.t('notifications.sc_invoiced_notification.html_message', link: invoice_link).html_safe
  end

  def default_subject
    I18n.t('notifications.sc_invoiced_notification.subject',
           ref:              invoice.invoiceable.ref_id,
           org:              invoice.organization.name,
           invoiceable_type: invoice.invoiceable.class.model_name.human)
  end

  def default_content
    I18n.t('notifications.sc_invoiced_notification.content', ref: invoice.ticket.ref_id)
  end

  private

  def invoice_link
    link_to Invoice.model_name.human.downcase, url_helpers.invoice_path(invoice)
  end

  def invoice
    notifiable
  end

end