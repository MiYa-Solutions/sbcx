class TransferredServiceCallObserver < ServiceCallObserver

  def before_accept(service_call, transition)
    service_call.events << ServiceCallAcceptEvent.new
    Rails.logger.debug { "invoked observer before accept \n #{service_call.inspect} \n #{transition.inspect}" }
  end

  def before_start_work(service_call, transition)
    Rails.logger.debug { "invoked observer BEFORE start \n #{service_call.inspect} \n #{transition.args.inspect}" }
    validate_technician_is_present(service_call)
    service_call.started_on = Time.zone.now unless service_call.started_on

  end

  def after_start_work(service_call, transition)
    service_call.events << ServiceCallStartEvent.new unless service_call.events.last.instance_of?(ServiceCallStartedEvent)
  end


  def before_settle(service_call, transition)
    service_call.settled_on = Time.now
    Rails.logger.debug { "invoked observer BEFORE settle \n #{service_call.inspect} \n #{transition.args.inspect}" }
  end

  def after_settle(service_call, transition)
    service_call.events << ServiceCallSettleEvent.new
    Rails.logger.debug { "invoked observer BEFORE settle \n #{service_call.inspect} \n #{transition.args.inspect}" }
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

  def before_provider_invoiced_payment(service_call, transition)
    service_call.events << ScProviderInvoicedEvent.new
  end


end