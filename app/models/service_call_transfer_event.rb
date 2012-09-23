class ServiceCallTransferEvent < Event

  def init
    self.name         = "Transferred Service Call"
    self.description  = "THE TRANSFER DESCRIPTION"
    self.reference_id = 2
  end

  def process_event
    Rails.logger.debug { "Running ServiceCallTransferEvent process" }

    service_call = associated_object

    new_service_call = service_call.dup

    new_service_call.organization = service_call.subcontractor
    new_service_call.provider_id  = service_call.organization_id
    new_service_call.save!

    Rails.logger.debug { "created new service call after transfer: #{new_service_call.inspect}" }
    new_service_call

  end


end