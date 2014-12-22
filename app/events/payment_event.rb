class PaymentEvent < EntryEvent

  protected

  def payment
    eventable
  end

  def ticket
    payment.ticket
  end
end
