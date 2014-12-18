class AffiliatePaymentObserver < ActiveRecord::Observer
  observe [PaymentToAffiliate.subclasses]

  def after_deposit(payment, transition)
    payment.events << AffPaymentDepositedEvent.new
  end

  def after_clear(payment, transition)
    payment.events << AffPaymentClearedEvent.new
  end

  def after_reject(payment, transition)
    payment.events << AffPaymentRejectedEvent.new
  end

end