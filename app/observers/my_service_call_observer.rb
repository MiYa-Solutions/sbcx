class MyServiceCallObserver < ServiceCallObserver
  def after_transfer(service_call, transition)
    service_call.events << ServiceCallTransferEvent.new
    Rails.logger.debug { "invoked observer after transfer \n #{service_call.inspect} \n #{transition.inspect}" }
  end

  def before_work_completed(service_call, transition)
    service_call.completed_on = Time.now
    Rails.logger.debug { "invoked observer BEFORE complete \n #{service_call.inspect} \n #{transition.args.inspect}" }
  end

  def before_transfer(service_call, transition)
    service_call.transfer_subcon
    Rails.logger.debug { "invoked observer BEFORE transfer \n #{service_call.inspect} \n #{transition.args.inspect}" }
  end

  def before_start(service_call, transition)
    service_call.started_on = Time.now
    Rails.logger.debug { "invoked observer BEFORE start \n #{service_call.inspect} \n #{transition.args.inspect}" }
  end

  def before_subcontractor_accepted(service_call, transition)
    service_call.accept_subcon
  end

  def before_subcontractor_rejected(service_call, transition)
    service_call.reject_subcon
  end

  def after_subcontractor_dispatched(service_call, transition)
    service_call.start_subcon
  end

  def after_subcontractor_completed(service_call, transition)
    service_call.complete_subcon
  end

  def before_subcontractor_settled(service_call, transition)
    service_call.settle_subcon
  end

  def before_paid(service_call, transition)
    service_call.paid_customer

  end


end