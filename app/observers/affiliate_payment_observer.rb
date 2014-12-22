class AffiliatePaymentObserver < ActiveRecord::Observer
  observe [PaymentToAffiliate.subclasses, PaymentFromAffiliate.subclasses]

  def after_deposit(payment, transition)
    payment.events << AffPaymentDepositedEvent.new(entry_id: payment.id)
  end

  def after_clear(payment, transition)
    payment.events << AffPaymentClearedEvent.new(entry_id: payment.id)
  end

  def after_reject(payment, transition)
    payment.events << AffPaymentRejectedEvent.new(entry_id: payment.id)
  end

  def after_confirm(payment, transition)
    payment.events << AffPaymentConfirmEvent.new(entry_id: payment.id)
  end

end