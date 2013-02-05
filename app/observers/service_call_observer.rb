class ServiceCallObserver < ActiveRecord::Observer

  def after_create(record)
    Rails.logger.debug { "invoked ServiceCallObserver after create" }
    record.ref_id ||= record.id
    record.save
  end

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

  def after_invoice_customer(service_call, transition)
    Rails.logger.debug { "invoked observer after invoice customer \n #{service_call.inspect} \n #{transition.inspect}" }
    service_call.events << ServiceCallInvoiceEvent.new unless service_call.events.map(&:type).include?("ServiceCallInvoicedEvent")
  end

  def before_paid_customer(service_call, transition)
    service_call.events << ServiceCallPaidEvent.new
    Rails.logger.debug { "invoked observer before paid customer \n #{service_call.inspect} \n #{transition.inspect}" }
  end

  #def before_subcontractor_accepted
  #  self.subcon_accept
  #end

  #
  #def after_update(record)
  #  Rails.logger.debug {"invoked observer after update"}
  #end
  #def after_transition(vehicle, transition)
  #  Rails.logger.debug { "invoked observer after transition" }
  #end


end
