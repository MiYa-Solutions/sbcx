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
    service_call.technician ||= service_call.creator
    Rails.logger.debug { "invoked observer BEFORE start \n #{service_call.inspect} \n #{transition.args.inspect}" }
  end


  def before_paid(service_call, transition)
    service_call.paid_customer

  end


end