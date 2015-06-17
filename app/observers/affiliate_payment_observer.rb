class AffiliatePaymentObserver < ActiveRecord::Observer
  # observe [PaymentToAffiliate.subclasses.map {|s|s.name.underscore.to_sym}, PaymentFromAffiliate.subclasses.map {|s|s.name.underscore.to_sym}].flatten
  observe PaymentToAffiliate, PaymentFromAffiliate

  def after_deposit(payment, transition)
    Rails.logger.debug { "AffiliatePaymentObserver: invoked observer AFTER after_deposit \n #{payment.inspect} \n #{transition.args.inspect}" }
    payment.ticket.events << AffPaymentDepositEvent.new(entry_id: payment.id)
  end

  def after_deposited(payment, transition)
    Rails.logger.debug { "AffiliatePaymentObserver: invoked observer AFTER after_deposited \n #{payment.inspect} \n #{transition.args.inspect}" }
    unless transition.args.first == :state_only
      payment.ticket.events << AffPaymentDepositedEvent.new(entry_id: payment.id)
    end
  end

  def after_cleared(payment, transition)
    Rails.logger.debug { "AffiliatePaymentObserver: invoked observer AFTER after_cleared \n #{payment.inspect} \n #{transition.args.inspect}" }
    unless transition.args.first == :state_only
      payment.events << AffPaymentClearedEvent.new(entry_id: payment.id)
    end
  end

  def after_clear(payment, transition)
    Rails.logger.debug { "AffiliatePaymentObserver: invoked observer AFTER after_clear \n #{payment.inspect} \n #{transition.args.inspect}" }
    payment.events << AffPaymentClearEvent.new(entry_id: payment.id)
  end

  def after_reject(payment, transition)
    Rails.logger.debug { "AffiliatePaymentObserver: invoked observer AFTER after_reject \n #{payment.inspect} \n #{transition.args.inspect}" }
    payment.events << AffPaymentRejectEvent.new(entry_id: payment.id)
  end

  def after_rejected(payment, transition)
    Rails.logger.debug { "AffiliatePaymentObserver: invoked observer AFTER after_rejected \n #{payment.inspect} \n #{transition.args.inspect}" }
    unless transition.args.first == :state_only
      payment.events << AffPaymentRejectedEvent.new(entry_id: payment.id)
    end

  end

  def after_confirm(payment, transition)
    Rails.logger.debug { "AffiliatePaymentObserver: invoked observer AFTER after_confirm \n #{payment.inspect} \n #{transition.args.inspect}" }
    payment.ticket.events << AffPaymentConfirmEvent.new(entry_id: payment.id)
  end

  def after_dispute(payment, transition)
    Rails.logger.debug { "AffiliatePaymentObserver: invoked observer AFTER after_dispute \n #{payment.inspect} \n #{transition.args.inspect}" }
    payment.events << AffPaymentDisputeEvent.new(entry_id: payment.id)
  end

  def after_disputed(payment, transition)
    Rails.logger.debug { "AffiliatePaymentObserver: invoked observer AFTER after_disputed \n #{payment.inspect} \n #{transition.args.inspect}" }
    unless transition.args.first == :state_only
      payment.events << AffPaymentDisputedEvent.new(entry_id: payment.id)
    end
  end

  def after_confirmed(payment, transition)
    Rails.logger.debug { "AffiliatePaymentObserver: invoked observer AFTER after_confirmed \n #{payment.inspect} \n #{transition.args.inspect}" }
    unless transition.args.first == :state_only
      payment.events << AffPaymentConfirmedEvent.new(entry_id: payment.id)
    end
  end


end