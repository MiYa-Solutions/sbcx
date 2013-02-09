class MyServiceCallObserver < ServiceCallObserver

  def after_dispatch(service_call, transition)
    service_call.events << ServiceCallDispatchEvent.new(description: I18n.t('service_call_dispatch_event.description', technician: service_call.technician.name))
    Rails.logger.debug { "invoked observer before dispatch \n #{service_call.inspect} \n #{transition.inspect}" }

  end

  #def before_start(service_call, transition)
  #  service_call.started_on = Time.now
  #  service_call.technician ||= service_call.creator
  #  Rails.logger.debug { "invoked observer BEFORE start \n #{service_call.inspect} \n #{transition.args.inspect}" }
  #end

  def before_start_work(service_call, transition)
    Rails.logger.debug { "invoked after BEFORE start \n #{service_call.inspect} \n #{transition.args.inspect}" }
    unless service_call.transferred?
      service_call.started_on = Time.zone.now unless service_call.started_on
      service_call.activate unless service_call.open?
      service_call.events << ServiceCallStartEvent.new
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

  def before_invoice_payment(service_call, transition)
    service_call.events << ServiceCallInvoiceEvent.new
  end


  #def before_paid(service_call, transition)
  #  service_call.events << ServiceCallPaidEvent.new
  #end

  #def before_settle(service_call, transition)
  #  service_call.events << ServiceCallSettleEvent.new
  #
  #end

  #def before_complete_subcon(service_call, transition)
  #  # don't take any action if the subcontractor is a member as the actions
  #  # are expected to be performed by the subcontractor itself through the status events
  #  unless service_call.subcontractor.subcontrax_member?
  #    service_call.completed_on = Time.zone.now
  #    service_call.events << ServiceCallCompletedEvent.new
  #  end
  #
  #end

  #def before_start_subcon(service_call, transition)
  #  # don't take any action if the subcontractor is a member as the actions
  #  # are expected to be performed by the subcontractor itself through the status events
  #  unless service_call.subcontractor.subcontrax_member?
  #    service_call.started_on = Time.zone.now
  #    service_call.events << ServiceCallStartedEvent.new
  #  end
  #
  #end

end