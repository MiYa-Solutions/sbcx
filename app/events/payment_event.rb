class PaymentEvent < EntryEvent

  protected


  def process_event
    unless notification_recipients.nil?
      notify notification_recipients, notification_class
    end
  end

  def notification_class
    nil
  end

  def payment
    entry
  end

  def ticket
    payment.ticket
  end
end
