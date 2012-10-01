class MyServiceCallObserver < ServiceCallObserver
  def after_transfer(service_call, transition)
    service_call.events << ServiceCallTransferEvent.new
    Rails.logger.debug { "invoked observer after transfer \n #{service_call.inspect} \n #{transition.inspect}" }
  end

  def before_transfer(service_call, transition)
    service_call.transfer_subcon
    Rails.logger.debug { "invoked observer BEFORE transfer \n #{service_call.inspect} \n #{transition.args.inspect}" }
  end

  def before_subcontractor_accepted(service_call, transition)
    service_call.accept_subcon
  end
end