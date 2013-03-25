class MyServiceCallObserver < ServiceCallObserver

  def after_clear_payment(service_call, transition)
    Rails.logger.debug { "invoked observer after clear payment \n #{service_call.inspect} \n #{transition.inspect}" }
    service_call.events << ScClearCustomerPaymentEvent.new
  end

  def after_start_work(service_call, transition)
    Rails.logger.debug { "invoked AFTER start_work \n #{service_call.inspect} \n #{transition.args.inspect}" }

    unless service_call.transferred?
      service_call.activate unless service_call.open?
      service_call.events << ServiceCallStartEvent.new
    end

  end

  def before_start_work(service_call, transition)
    Rails.logger.debug { "invoked BEFORE start_work \n #{service_call.inspect} \n #{transition.args.inspect}" }

    service_call.started_on = Time.zone.now unless service_call.started_on

  end

  def after_work_dispatch(service_call, transition)
    service_call.activate
    service_call.events << ServiceCallDispatchEvent.new
  end

  def after_dispatch_work(service_call, transition)
    Rails.logger.debug { "invoked AFTER dispatch \n #{service_call.inspect} \n #{transition.args.inspect}" }

    service_call.activate
    service_call.events << ServiceCallDispatchEvent.new
  end

  # todo change to before callback after implementing background processing
  def after_invoice_payment(service_call, transition)
    service_call.events << ServiceCallInvoiceEvent.new
  end

  def after_paid_payment(service_call, transition)
    Rails.logger.debug { "invoked AFTER paid \n #{service_call.inspect} \n #{transition.args.inspect}" }

    service_call.events << ServiceCallPaidEvent.new
  end

  def before_collect_payment(service_call, transition)
    Rails.logger.debug { "invoked BEFORE collect \n #{service_call.inspect} \n #{transition.args.inspect}" }
    service_call.collector_type = "User"

  end

  def before_overdue_payment(service_call, transition)
    Rails.logger.debug { "invoked BEFORE overdue \n #{service_call.inspect} \n #{transition.args.inspect}" }
    service_call.events << ScPaymentOverdueEvent.new
  end


end