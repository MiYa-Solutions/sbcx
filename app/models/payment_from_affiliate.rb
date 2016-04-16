class PaymentFromAffiliate < AffiliateSettlementEntry
  include ReceivedConfirmableEntry

  def amount_direction
    -1
  end
  #
  # state_machine :status do
  #   after_transition on: :deposit, do: :after_deposit
  #   after_transition on: :clear, do: :after_clear
  #   after_transition on: :reject, do: :after_reject
  #   after_transition on: :confirm, do: :after_confirm
  #   after_transition on: :dispute, do: :after_dispute
  # end
  #
  # def after_deposit(payment, transition)
  #   Rails.logger.debug { "AffiliatePaymentObserver: invoked observer AFTER after_deposit \n #{payment.inspect} \n #{transition.args.inspect}" }
  #   payment.ticket.events << AffPaymentDepositEvent.new(entry_id: payment.id)
  # end
  #
  #
  # def after_clear(payment, transition)
  #   Rails.logger.debug { "AffiliatePaymentObserver: invoked observer AFTER after_clear \n #{payment.inspect} \n #{transition.args.inspect}" }
  #   payment.events << AffPaymentClearEvent.new(entry_id: payment.id)
  # end
  #
  # def after_reject(payment, transition)
  #   Rails.logger.debug { "AffiliatePaymentObserver: invoked observer AFTER after_reject \n #{payment.inspect} \n #{transition.args.inspect}" }
  #   payment.ticket.events << AffPaymentRejectEvent.new(entry_id: payment.id)
  # end
  #
  #
  # def after_confirm(payment, transition)
  #   Rails.logger.debug { "AffiliatePaymentObserver: invoked observer AFTER after_confirm \n #{payment.inspect} \n #{transition.args.inspect}" }
  #   payment.ticket.events << AffPaymentConfirmEvent.new(entry_id: payment.id)
  # end
  #
  # def after_dispute(payment, transition)
  #   Rails.logger.debug { "AffiliatePaymentObserver: invoked observer AFTER after_dispute \n #{payment.inspect} \n #{transition.args.inspect}" }
  #   payment.events << AffPaymentDisputeEvent.new(entry_id: payment.id)
  # end
  #

end