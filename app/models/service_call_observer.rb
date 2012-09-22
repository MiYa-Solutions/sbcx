class ServiceCallObserver < ActiveRecord::Observer

  #def after_save(record)
  #  Rails.logger.debug {"invoked observer after save"}
  #end
  #
  #def after_create(record)
  #  Rails.logger.debug {"invoked observer after create"}
  #end
  #
  #def after_update(record)
  #  Rails.logger.debug {"invoked observer after update"}
  #end
  #def after_transition(vehicle, transition)
  #  Rails.logger.debug { "invoked observer after transition" }
  #end

  def after_transfer(service_call, transition)
    service_call.events << ServiceCallTransferEvent.new
    Rails.logger.debug { "invoked observer after transfer \n #{service_call.inspect} \n #{transition.inspect}" }
  end

end
