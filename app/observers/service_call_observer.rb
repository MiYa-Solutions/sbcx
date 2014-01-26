class ServiceCallObserver < ActiveRecord::Observer

  def after_create(record)
    Rails.logger.debug { "invoked ServiceCallObserver after create" }
    #record.ref_id ||= record.id
    #record.save
  end

  def after_close(service_call, transition)
    service_call.events << ScCloseEvent.new
  end

  def after_cancel(service_call, transition)
    service_call.events << ServiceCallCancelEvent.new unless transition.args.first == :state_only
  end

  def after_un_cancel(service_call, transition)
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

  # todo the unless clause doesn't seem safe in case other events happen after the corresponding one - revise
  def after_complete_work(service_call, transition)
    Rails.logger.debug { "invoked observer AFTER complete \n #{service_call.inspect} \n #{transition.args.inspect}" }
    service_call.events << ServiceCallCompleteEvent.new unless transition.args.first == :state_only
  end

  # todo the unless clause doesn't seem safe in case other events happen after the corresponding one - revise
  def before_reject_work(service_call, transition)
    Rails.logger.debug { "invoked observer BEFORE reject \n #{service_call.inspect} \n #{transition.args.inspect}" }
    service_call.events << ServiceCallRejectEvent.new unless transition.args.first == :state_only
  end

  def after_subcon_invoiced_payment(service_call, transition)
    Rails.logger.debug { "invoked observer before subcon_invoice \n #{service_call.inspect} \n #{transition.inspect}" }
    service_call.events << ServiceCallInvoicedEvent.new unless transition.args.first == :state_only
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

  def after_subcon_collected_payment(service_call, transition)
    Rails.logger.debug { "invoked observer AFTER subcon_collected_payment \n #{service_call.inspect} \n #{transition.args.inspect}" }
    service_call.events << ScCollectedEvent.new(amount: service_call.payment_amount) unless transition.args.first == :state_only

  end

end
