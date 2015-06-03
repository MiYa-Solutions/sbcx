class AffiliatePaymentObserver < ActiveRecord::Observer
  observe [PaymentToAffiliate.subclasses, PaymentFromAffiliate.subclasses]

  def after_deposit(payment, transition)
    payment.events << AffPaymentDepositEvent.new(entry_id: payment.id)
  end

  def after_deposited(payment, transition)
    unless transition.args.first == :state_only
      payment.events << AffPaymentDepositedEvent.new(entry_id: payment.id)
    end
  end

  def after_cleared(payment, transition)
    unless transition.args.first == :state_only
      payment.events << AffPaymentClearedEvent.new(entry_id: payment.id)
    end
  end

  def after_clear(payment, transition)
    payment.events << AffPaymentClearEvent.new(entry_id: payment.id)
  end

  def after_reject(payment, transition)
    payment.events << AffPaymentRejectEvent.new(entry_id: payment.id)
  end

  def after_rejected(payment, transition)
    unless transition.args.first == :state_only
      payment.events << AffPaymentRejectedEvent.new(entry_id: payment.id)
    end

  end

  def after_confirm(payment, transition)
    payment.events << AffPaymentConfirmEvent.new(entry_id: payment.id)
  end

  def after_dispute(payment, transition)
    payment.events << AffPaymentDisputeEvent.new(entry_id: payment.id)
  end

  def after_disputed(payment, transition)
    unless transition.args.first == :state_only
      payment.events << AffPaymentDisputedEvent.new(entry_id: payment.id)
    end
  end

  def after_confirmed(payment, transition)
    unless transition.args.first == :state_only
      payment.events << AffPaymentConfirmedEvent.new(entry_id: payment.id)
    end
  end


end