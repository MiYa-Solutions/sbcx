class CustomerPaymentObserver < ActiveRecord::Observer

  def after_deposit(payment, transition)
    payment.events << PaymentDepositedEvent.new(entry_id: payment.id)
  end

  def after_clear(payment, transition)
    payment.events << PaymentClearedEvent.new(entry_id: payment.id)
  end

  def after_reject(payment, transition)
    payment.events << PaymentRejectedEvent.new(entry_id: payment.id)
  end

end