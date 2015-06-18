class PaymentFromAffiliateObserver < ActiveRecord::Observer
  observe PaymentFromAffiliate.subclasses

  def after_deposit(payment, transition)
    Rails.logger.debug { "AffiliatePaymentObserver: invoked observer AFTER after_deposit \n #{payment.inspect} \n #{transition.args.inspect}" }
    payment.ticket.events << AffPaymentDepositEvent.new(entry_id: payment.id)
  end

  def after_clear(payment, transition)
    Rails.logger.debug { "AffiliatePaymentObserver: invoked observer AFTER after_clear \n #{payment.inspect} \n #{transition.args.inspect}" }
    payment.ticket.events << AffPaymentClearEvent.new(entry_id: payment.id)
  end

  def after_reject(payment, transition)
    Rails.logger.debug { "AffiliatePaymentObserver: invoked observer AFTER after_reject \n #{payment.inspect} \n #{transition.args.inspect}" }
    payment.ticket.events << AffPaymentRejectEvent.new(entry_id: payment.id)
  end

  def after_confirm(payment, transition)
    Rails.logger.debug { "AffiliatePaymentObserver: invoked observer AFTER after_confirm \n #{payment.inspect} \n #{transition.args.inspect}" }
    payment.ticket.events << AffPaymentConfirmEvent.new(entry_id: payment.id)
  end

  def after_dispute(payment, transition)
    Rails.logger.debug { "AffiliatePaymentObserver: invoked observer AFTER after_dispute \n #{payment.inspect} \n #{transition.args.inspect}" }
    payment.ticket.events << AffPaymentDisputeEvent.new(entry_id: payment.id)
  end


end