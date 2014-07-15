class CustomerPaymentObserver < ActiveRecord::Observer

  def after_deposit(payment, transition)
    payment.events << PaymentDepositedEvent.new
  end

  def after_clear(payment, transition)
    payment.events << PaymentClearedEvent.new
  end

  def after_reject(payment, transition)
    payment.events << PaymentRejectedEvent.new
  end

end