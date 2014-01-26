class TransferredServiceCallObserver < ServiceCallObserver


  def after_deposit_to_prov_payment(service_call, transition)
    Rails.logger.debug { "invoked observer BEFORE deposit_to_prov \n #{service_call.inspect} \n #{transition.inspect}" }
    service_call.events << ScDepositEvent.new
  end

  def after_subcon_deposited_payment(service_call, transition)
    Rails.logger.debug { "invoked observer BEFORE deposit_to_prov \n #{service_call.inspect} \n #{transition.inspect}" }
    service_call.events << ScSubconDepositedEvent.new
  end

  def after_clear_provider(service_call, transition)
    Rails.logger.debug { "invoked observer AFTER clear_provider \n #{service_call.inspect} \n #{transition.inspect}" }
    service_call.events << ScProviderClearEvent.new

  end

  def after_prov_confirmed_deposit_payment(service_call, transition)
    Rails.logger.debug { "invoked observer BEFORE deposit_to_prov \n #{service_call.inspect} \n #{transition.inspect}" }
    service_call.events << ScDepositConfirmedEvent.new unless service_call.events.order('id desc').first.instance_of?(ScDepositConfirmedEvent)
  end

  def before_accept(service_call, transition)
    Rails.logger.debug { "invoked observer before accept \n #{service_call.inspect} \n #{transition.inspect}" }
    service_call.events << ServiceCallAcceptEvent.new
  end

  def before_collect_payment(service_call, transition)
    Rails.logger.debug { "invoked observer BEFORE collect \n #{service_call.inspect} \n #{transition.inspect}" }
    service_call.collector_type = "User" unless service_call.collector_type
  end

  def after_collect_payment(service_call, transition)
    Rails.logger.debug { "invoked observer AFTER collect \n #{service_call.inspect} \n #{transition.args.inspect}" }
    service_call.events << ScCollectEvent.new(amount: service_call.payment_amount)
  end

  def before_start_work(service_call, transition)
    Rails.logger.debug { "invoked observer BEFORE start \n #{service_call.inspect} \n #{transition.args.inspect}" }
    service_call.started_on = Time.zone.now unless service_call.started_on
  end

  def after_start_work(service_call, transition)
    Rails.logger.debug { "invoked observer AFTER start \n #{service_call.inspect} \n #{transition.args.inspect}\n transition args: #{transition.args}" }
    service_call.events << ServiceCallStartEvent.new unless transition.args.first == :state_only
  end

  def before_subcontractor_accepted(service_call, transition)
    service_call.accept_subcon
  end

  def after_dispatch_work(service_call, transition)
    Rails.logger.debug { "invoked observer before dispatch \n #{service_call.inspect} \n #{transition.inspect}" }
    service_call.events << ServiceCallDispatchEvent.new
  end

  def after_reject(service_call, transition)
    Rails.logger.debug { "invoked observer after reject \n #{service_call.inspect} \n #{transition.inspect}\n transition args: #{transition.args}" }
    service_call.events << ServiceCallRejectEvent.new unless transition.args.first == :state_only
  end

  def before_invoice_payment(service_call, transition)
    Rails.logger.debug { "invoked observer before invoice \n #{service_call.inspect} \n #{transition.inspect}" }
    service_call.events << ServiceCallInvoiceEvent.new
  end

  def after_provider_invoiced_payment(service_call, transition)
    Rails.logger.debug { "invoked observer after provider_invoiced \n #{service_call.inspect} \n #{transition.inspect}\n transition args: #{transition.args}" }
    service_call.events << ScProviderInvoicedEvent.new unless transition.args.first == :state_only
  end

  def after_settle_provider(service_call, transition)
    service_call.events << ScProviderSettleEvent.new
  end

  def before_confirm_settled_provider(service_call, transition)
    Rails.logger.debug { "invoked observer BEFORE confirm_settled_provider \n #{service_call.inspect} \n #{transition.args.inspect}" }
    service_call.events << ScConfirmSettledProviderEvent.new

  end

end