class PaymentToAffiliate < AffiliateSettlementEntry
  include InitiatedConfirmableEntry
  include InitiatedDepositableEntry

  def amount_direction
    1
  end

  def allowed_status_events
    if account.accountable.member?
      []
    else
      [:deposited, :cleared, :rejected, :confirmed, :disputed] & self.status_events
    end
  end

  # state_machine :status do
  #   after_transition on: :deposited, do: :after_deposited
  #   after_transition on: :cleared, do: :after_cleared
  #   after_transition on: :rejected, do: :after_rejected
  #   after_transition on: :confirmed, do: :after_confirmed
  #   after_transition on: :disputed, do: :after_disputed
  # end
  #
  def confirm_affiliate_status
    ticket.subcon_confirmed_subcon! if ticket.can_subcon_confirmed_subcon?
  end

  def dispute_affiliate_status
    ticket.subcon_disputed_subcon! if ticket.can_subcon_disputed_subcon?
  end

  # def after_deposited(payment, transition)
  #   Rails.logger.debug { "AffiliatePaymentObserver: invoked observer AFTER after_deposited \n #{payment.inspect} \n #{transition.args.inspect}" }
  #   unless transition.args.first == :state_only
  #     payment.ticket.events << AffPaymentDepositedEvent.new(entry_id: payment.id)
  #   end
  # end
  #
  # def after_cleared(payment, transition)
  #   Rails.logger.debug { "AffiliatePaymentObserver: invoked observer AFTER after_cleared \n #{payment.inspect} \n #{transition.args.inspect}" }
  #   unless transition.args.first == :state_only
  #     payment.ticket.events << AffPaymentClearedEvent.new(entry_id: payment.id)
  #   end
  # end
  #
  # def after_rejected(payment, transition)
  #   Rails.logger.debug { "AffiliatePaymentObserver: invoked observer AFTER after_rejected \n #{payment.inspect} \n #{transition.args.inspect}" }
  #   unless transition.args.first == :state_only
  #     payment.events << AffPaymentRejectedEvent.new(entry_id: payment.id)
  #   end
  #
  # end
  #
  # def after_disputed(payment, transition)
  #   Rails.logger.debug { "AffiliatePaymentObserver: invoked observer AFTER after_disputed \n #{payment.inspect} \n #{transition.args.inspect}" }
  #   unless transition.args.first == :state_only
  #     payment.events << AffPaymentDisputedEvent.new(entry_id: payment.id)
  #   end
  # end
  #
  # def after_confirmed(payment, transition)
  #   Rails.logger.debug { "AffiliatePaymentObserver: invoked observer AFTER after_confirmed \n #{payment.inspect} \n #{transition.args.inspect}" }
  #   unless transition.args.first == :state_only
  #     payment.events << AffPaymentConfirmedEvent.new(entry_id: payment.id)
  #   end
  # end
  #


end