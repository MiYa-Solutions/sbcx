class MyServiceCallObserver < ServiceCallObserver
  def after_transfer(service_call, transition)
    service_call.events << ServiceCallTransferEvent.new(description: I18n.t('service_call_transfer_event.description', subcontractor_name: service_call.subcontractor.name))
    Rails.logger.debug { "invoked observer after transfer \n #{service_call.inspect} \n #{transition.inspect}" }
  end

  def after_dispatch(service_call, transition)
    service_call.events << ServiceCallDispatchEvent.new(description: I18n.t('service_call_dispatch_event.description', technician: service_call.technician.name))
    Rails.logger.debug { "invoked observer before dispatch \n #{service_call.inspect} \n #{transition.inspect}" }

  end

  def before_work_completed(service_call, transition)
    service_call.completed_on = Time.now
    Rails.logger.debug { "invoked observer BEFORE complete \n #{service_call.inspect} \n #{transition.args.inspect}" }
  end

  def after_work_completed(service_call, transition)
    service_call.events << ServiceCallCompleteEvent.new(description: I18n.t('service_call_complete_event.description', technician: service_call.technician.name))
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

  def after_start(service_call, transition)
    service_call.events << ServiceCallStartEvent.new
    Rails.logger.debug { "invoked observer BEFORE start \n #{service_call.inspect} \n #{transition.args.inspect}" }
  end


  def before_paid(service_call, transition)

    service_call.events << ServiceCallPaidEvent.new(description: I18n.t('service_call_paid_event.description'))
  end


  def before_cancel(service_call, transition)
    service_call.events << ServiceCallCancelEvent.new(description: I18n.t('service_call_cancel_event.description'))

  end

end