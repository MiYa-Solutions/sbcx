class MyServiceCallObserver < ServiceCallObserver

  def after_clear_payment(service_call, transition)
    Rails.logger.debug { "invoked observer after clear payment \n #{service_call.inspect} \n #{transition.inspect}" }
    service_call.events << ScClearCustomerPaymentEvent.new
  end

  def after_clear_subcon(service_call, transition)
    Rails.logger.debug { "invoked observer after clear payment \n #{service_call.inspect} \n #{transition.inspect}" }
    service_call.events << ScSubconClearEvent.new
  end

  def after_start_work(service_call, transition)
    Rails.logger.debug { "invoked AFTER start_work \n #{service_call.inspect} \n #{transition.args.inspect}" }

    if service_call.transferred?
      service_call.events << ServiceCallStartedEvent.new unless transition.args.first == :state_only
    else
      service_call.activate unless  service_call.open?
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

    service_call.events << ServiceCallPaidEvent.new(amount:       service_call.payment_money,
                                                    payment_type: service_call.payment_type)
  end

  def after_collect_payment(service_call, transition)
    Rails.logger.debug { "invoked AFTER collect \n #{service_call.inspect} \n #{transition.args.inspect}" }
    unless transition.args.first == :state_only
      service_call.collector_type = 'User'
      service_call.events << ScCollectedEvent.new(amount:       service_call.payment_money,
                                                  payment_type: service_call.payment_type,
                                                  collector:    service_call.collector)
    end

  end

  def after_deposited_payment(service_call, transition)
    Rails.logger.debug { "invoked AFTER deposited \n #{service_call.inspect} \n #{transition.args.inspect}" }
    service_call.collector_type = 'User'
    service_call.events << ScEmployeeDepositedEvent.new(amount:       service_call.payment_money,
                                                        payment_type: service_call.payment_type)
  end

  def before_overdue_payment(service_call, transition)
    Rails.logger.debug { "invoked BEFORE overdue \n #{service_call.inspect} \n #{transition.args.inspect}" }
    service_call.events << ScPaymentOverdueEvent.new
  end

  def after_reject_payment(service_call, transition)
    Rails.logger.debug { "invoked AFTER overdue \n #{service_call.inspect} \n #{transition.args.inspect}" }
    service_call.events << ScPaymentRejectedEvent.new
  end


end