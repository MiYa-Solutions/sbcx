class PaymentToAffiliateObserver < ActiveRecord::Observer
  observe :cash_payment_to_affiliate, :credit_payment_to_affiliate, :amex_payment_to_affiliate, :credit_payment_to_affiliate, :cheque_payment_to_affiliate

  def after_deposited(payment, transition)
    Rails.logger.debug { "AffiliatePaymentObserver: invoked observer AFTER after_deposited \n #{payment.inspect} \n #{transition.args.inspect}" }
    unless transition.args.first == :state_only
      payment.ticket.events << AffPaymentDepositedEvent.new(entry_id: payment.id)
    end
  end

  def after_cleared(payment, transition)
    Rails.logger.debug { "AffiliatePaymentObserver: invoked observer AFTER after_cleared \n #{payment.inspect} \n #{transition.args.inspect}" }
    unless transition.args.first == :state_only
      payment.ticket.events << AffPaymentClearedEvent.new(entry_id: payment.id)
    end
  end

  def after_rejected(payment, transition)
    Rails.logger.debug { "AffiliatePaymentObserver: invoked observer AFTER after_rejected \n #{payment.inspect} \n #{transition.args.inspect}" }
    unless transition.args.first == :state_only
      payment.ticket.events << AffPaymentRejectedEvent.new(entry_id: payment.id)
    end

  end

  def after_disputed(payment, transition)
    Rails.logger.debug { "AffiliatePaymentObserver: invoked observer AFTER after_disputed \n #{payment.inspect} \n #{transition.args.inspect}" }
    unless transition.args.first == :state_only
      payment.ticket.events << AffPaymentDisputedEvent.new(entry_id: payment.id)
    end
  end

  def after_confirmed(payment, transition)
    Rails.logger.debug { "AffiliatePaymentObserver: invoked observer AFTER after_confirmed \n #{payment.inspect} \n #{transition.args.inspect}" }
    unless transition.args.first == :state_only
      payment.ticket.events << AffPaymentConfirmedEvent.new(entry_id: payment.id)
    end
  end


end