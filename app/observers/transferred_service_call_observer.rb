class TransferredServiceCallObserver < ServiceCallObserver


  def before_deposit_to_prov_payment(service_call, transition)
    Rails.logger.debug { "invoked observer BEFORE deposit_to_prov \n #{service_call.inspect} \n #{transition.inspect}" }
    service_call.events << ScDepositEvent.new
  end

  def before_accept(service_call, transition)
    Rails.logger.debug { "invoked observer before accept \n #{service_call.inspect} \n #{transition.inspect}" }
    service_call.events << ServiceCallAcceptEvent.new
  end

  def before_collect_payment(service_call, transition)
    Rails.logger.debug { "invoked observer BEFORE collect \n #{service_call.inspect} \n #{transition.inspect}" }
    service_call.collector_type = "User" unless service_call.collector_type
    service_call.events << ScCollectEvent.new
  end

  def after_collect_payment(service_call, transition)
    Rails.logger.debug { "invoked observer AFTER collect \n #{service_call.inspect} \n #{transition.args.inspect}" }
  end

  def before_start_work(service_call, transition)
    Rails.logger.debug { "invoked observer BEFORE start \n #{service_call.inspect} \n #{transition.args.inspect}" }
    service_call.started_on = Time.zone.now unless service_call.started_on
  end

  def after_start_work(service_call, transition)
    Rails.logger.debug { "invoked observer AFTER start \n #{service_call.inspect} \n #{transition.args.inspect}" }
    service_call.events << ServiceCallStartEvent.new unless service_call.events.last.instance_of?(ServiceCallStartedEvent)
  end

  def before_subcontractor_accepted(service_call, transition)
    service_call.accept_subcon
  end

  def after_dispatch_work(service_call, transition)
    Rails.logger.debug { "invoked observer before dispatch \n #{service_call.inspect} \n #{transition.inspect}" }
    service_call.events << ServiceCallDispatchEvent.new
  end

  def after_reject(service_call, transition)
    Rails.logger.debug { "invoked observer after reject \n #{service_call.inspect} \n #{transition.inspect}" }
    service_call.events << ServiceCallRejectEvent.new unless service_call.events.last.instance_of?(ServiceCallRejectedEvent)
  end

  def before_invoice_payment(service_call, transition)
    Rails.logger.debug { "invoked observer before invoice \n #{service_call.inspect} \n #{transition.inspect}" }
    service_call.events << ServiceCallInvoiceEvent.new
  end

  def after_provider_invoiced_payment(service_call, transition)
    service_call.events << ScProviderInvoicedEvent.new unless service_call.events.last.instance_of?(ScProviderInvoicedEvent)
  end

  def before_settle_provider(service_call, transition)
    service_call.events << ScProviderSettleEvent.new
  end

  def before_confirm_settled_provider(service_call, transition)
    Rails.logger.debug { "invoked observer BEFORE confirm_settled_provider \n #{service_call.inspect} \n #{transition.args.inspect}" }
    service_call.events << ScConfirmSettledProviderEvent.new

  end

  def before_transfer(service_call, transition)
    super
    if service_call.validate_circular_transfer
      service_call.errors.add :subcontractor, I18n.t('activerecord.errors.ticket.circular_transfer')
    end
  end


end