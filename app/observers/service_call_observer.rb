class ServiceCallObserver < ActiveRecord::Observer

  def before_collect_payment(service_call, transition)
    Rails.logger.debug { "invoked observer BEFORE collect \n #{service_call.inspect} \n #{transition.inspect}" }
    service_call.collector_type = "User" unless service_call.collector_type
  end

  def after_collect_payment(service_call, transition)
    Rails.logger.debug { "invoked observer AFTER collect \n #{service_call.inspect} \n #{transition.args.inspect}" }
    unless transition.args.first == :state_only
      ActiveSupport::Deprecation.silence do
        service_call.events << ScCollectEvent.new(amount:       service_call.payment_money,
                                                  payment_type: service_call.payment_type,
                                                  collector:    service_call.collector,
                                                  notes:        service_call.payment_notes)
      end
    end
  end

  def after_close(service_call, transition)
    service_call.events << ScCloseEvent.new
  end

  def after_reset(service_call, transition)
    service_call.events << ScResetEvent.new
  end

  def after_cancel(service_call, transition)
    service_call.events << ServiceCallCancelEvent.new unless transition.args.first == :state_only
  end

  def after_cancel_transfer(service_call, transition)
    service_call.events << ScCancelTransferEvent.new
  end

  def after_un_cancel(service_call, transition)
    service_call.events << ServiceCallUnCancelEvent.new
  end


  def before_transfer(service_call, transition)
    Rails.logger.debug { "invoked observer BEFORE transfer \n #{service_call.inspect} \n #{transition.args.inspect}" }
    #service_call.subcontractor_status = ServiceCall::SUBCON_STATUS_PENDING
    #service_call.subcon_collection_status = CollectionStateMachine::STATUS_PENDING if service_call.allow_collection?
  end


  # todo move the event association to before transfer after implementing background processing for events.
  # the reason is because with background processing the service call will be saved with the new subcontractor
  def after_transfer(service_call, transition)
    Rails.logger.debug { "invoked observer after transfer \n #{service_call.inspect} \n #{transition.inspect}" }
    service_call.subcontractor_status     = AffiliateSettlement::STATUS_PENDING
    service_call.subcon_collection_status = CollectionStateMachine::STATUS_PENDING if service_call.allow_collection?
    service_call.events << ServiceCallTransferEvent.new
    service_call.save
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

  def before_reject_work(service_call, transition)
    Rails.logger.debug { "invoked observer BEFORE reject \n #{service_call.inspect} \n #{transition.args.inspect}" }
    service_call.events << ServiceCallRejectEvent.new unless transition.args.first == :state_only
  end

  def after_accept_work(service_call, transition)
    Rails.logger.debug { "invoked observer BEFORE accept_work \n #{service_call.inspect} \n #{transition.args.inspect}" }
    service_call.events << ServiceCallAcceptedEvent.new unless transition.args.first == :state_only
  end

  def after_reopen_work(service_call, transition)
    Rails.logger.debug { "invoked observer AFTER reopen_work \n #{service_call.inspect} \n #{transition.args.inspect}" }
    service_call.events << ScWorkReopenEvent.new unless transition.args.first == :state_only
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
    if service_call.subcon_settlement_attributes_valid?
      service_call.settled_on = Time.zone.now
      service_call.events << ScSubconSettleEvent.new(amount:       service_call.subcon_settle_money,
                                                     payment_type: service_call.subcon_settle_type,
                                                     notes:        service_call.payment_notes)
    end
  end

  def after_settle_subcon(service_call, transition)
    Rails.logger.debug { "invoked observer AFTER settle_subcon \n #{service_call.inspect} \n #{transition.args.inspect}" }
  end

  def before_confirm_settled_subcon(service_call, transition)
    Rails.logger.debug { "invoked observer BEFORE confirm_settled_subcon \n #{service_call.inspect} \n #{transition.args.inspect}" }
    service_call.events << ScConfirmSettledSubconEvent.new

  end

  def after_subcon_collected_payment(service_call, transition)
    Rails.logger.debug { "invoked observer AFTER subcon_collected_payment \n #{service_call.inspect} \n #{transition.args.inspect}" }
    service_call.events << ScCollectedEvent.new(amount:       service_call.payment_money,
                                                payment_type: service_call.payment_type,
                                                collector:    service_call.collector,
                                                notes:        service_call.payment_notes) unless transition.args.first == :state_only

  end

end
