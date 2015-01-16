class AffiliatePaymentNotification < Notification
  def entry
    @entry ||= notifiable
  end

  def affiliate
    @affiliate ||= entry.accountable
  end

  def ticket_link
    link_to ServiceCall.model_name.human.downcase, url_helpers.service_call_path(ticket)
  end

  def ticket
    entry.ticket
  end

end