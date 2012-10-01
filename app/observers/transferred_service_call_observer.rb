class TransferredServiceCallObserver < ServiceCallObserver
  def after_transfer(service_call, transition)
    service_call.events << ServiceCallTransferEvent.new
    Rails.logger.debug { "invoked observer after transfer \n #{service_call.inspect} \n #{transition.inspect}" }
  end

  def before_transfer(service_call, transition)
    service_call.subcon_transfer_subcon
    Rails.logger.debug { "invoked observer BEFORE transfer \n #{service_call.inspect} \n #{transition.args.inspect}" }
  end

  def before_accept(service_call, transition)
    service_call.events << ServiceCallAcceptEvent.new

    Rails.logger.debug { "invoked observer after accept \n #{service_call.inspect} \n #{transition.inspect}" }
  end

  def before_subcontractor_accepted
    self.subcon_accept
  end
end