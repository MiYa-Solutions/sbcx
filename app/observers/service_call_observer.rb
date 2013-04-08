class ServiceCallObserver < ActiveRecord::Observer

  def after_create(record)
    Rails.logger.debug { "invoked ServiceCallObserver after create" }
    record.ref_id ||= record.id
    record.save
  end

  def after_close(service_call, transition)
    service_call.events << ScCloseEvent.new
  end

  def after_cancel(service_call, transition)
    service_call.events << ServiceCallCancelEvent.new
  end
  def before_un_cancel(service_call, transition)
    service_call.events << ServiceCallUnCancelEvent.new
  end


  def before_transfer(service_call, transition)
    Rails.logger.debug { "invoked observer BEFORE transfer \n #{service_call.inspect} \n #{transition.args.inspect}" }
    service_call.subcontractor_status = ServiceCall::SUBCON_STATUS_PENDING
  end


  # todo move the event association to before transfer after implementing background processing for events.
  # the reason is because with background processing the service call will be saved with the new subcontractor
  def after_transfer(service_call, transition)
    Rails.logger.debug { "invoked observer after transfer \n #{service_call.inspect} \n #{transition.inspect}" }
    service_call.events << ServiceCallTransferEvent.new
  end

  def before_accept(service_call, transition)
    Rails.logger.debug { "invoked observer BEFORE accept \n #{service_call.inspect} \n #{transition.inspect}" }
    service_call.events << ServiceCallAcceptEvent.new
  end

  def before_complete_work(service_call, transition)
    Rails.logger.debug { "invoked observer BEFORE complete \n #{service_call.inspect} \n #{transition.args.inspect}" }
    service_call.completed_on = Time.zone.now unless service_call.completed_on
  end

  def after_complete_work(service_call, transition)
    Rails.logger.debug { "invoked observer AFTER complete \n #{service_call.inspect} \n #{transition.args.inspect}" }
    service_call.events << ServiceCallCompleteEvent.new unless service_call.events.last.instance_of?(ServiceCallCompletedEvent)
  end

  def before_reject_work(service_call, transition)
    Rails.logger.debug { "invoked observer BEFORE reject \n #{service_call.inspect} \n #{transition.args.inspect}" }
    service_call.events << ServiceCallRejectEvent.new unless service_call.events.last.instance_of?(ServiceCallRejectedEvent)
  end

  def after_subcon_invoiced_payment(service_call, transition)
    Rails.logger.debug { "invoked observer before subcon_invoice \n #{service_call.inspect} \n #{transition.inspect}" }
    service_call.events << ServiceCallInvoicedEvent.new unless service_call.events.last.instance_of?(ServiceCallInvoicedEvent)
  end

  def before_confirm_deposit_payment(service_call, transition)
    Rails.logger.debug { "invoked observer BEFORE confirm_deposit \n #{service_call.inspect} \n #{transition.inspect}" }
    service_call.events << ScConfirmDepositEvent.new
  end

  def before_settle_subcon(service_call, transition)
    Rails.logger.debug { "invoked observer BEFORE settle_subcon \n #{service_call.inspect} \n #{transition.args.inspect}" }

    service_call.settled_on = Time.zone.now
  end

  def after_settle_subcon(service_call, transition)
    Rails.logger.debug { "invoked observer AFTER settle_subcon \n #{service_call.inspect} \n #{transition.args.inspect}" }
    service_call.events << ScSubconSettleEvent.new
  end

  def before_confirm_settled_subcon(service_call, transition)
    Rails.logger.debug { "invoked observer BEFORE confirm_settled_subcon \n #{service_call.inspect} \n #{transition.args.inspect}" }
    service_call.events << ScConfirmSettledSubconEvent.new

  end

end
