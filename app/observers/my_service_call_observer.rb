class MyServiceCallObserver < ServiceCallObserver

  def after_dispatch(service_call, transition)
    service_call.events << ServiceCallDispatchEvent.new(description: I18n.t('service_call_dispatch_event.description', technician: service_call.technician.name))
    Rails.logger.debug { "invoked observer before dispatch \n #{service_call.inspect} \n #{transition.inspect}" }

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

    unless service_call.transferred?
      #validate_technician_is_present(service_call)
      service_call.started_on = Time.zone.now unless service_call.started_on
    end

  end

  def after_work_dispatch(service_call, transition)
    service_call.activate
    service_call.events << ServiceCallDispatchEvent.new
  end

  def after_dispatch_work(service_call, transition)
    service_call.activate
    service_call.events << ServiceCallDispatchEvent.new
  end

  # todo change to before callback after implementing background processing
  def after_invoice_payment(service_call, transition)
    service_call.events << ServiceCallInvoiceEvent.new
  end


end