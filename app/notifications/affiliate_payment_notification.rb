class AffiliatePaymentNotification < Notification
  include MoneyRails::ActionViewExtension

  def entry
    @entry ||= event.entry
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

  def ticket_ref
    ticket.ref_id
  end

end