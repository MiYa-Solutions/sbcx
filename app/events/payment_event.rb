class PaymentEvent < Event

  protected

  def payment
    eventable
  end

  def ticket
    payment.ticket
  end
end
