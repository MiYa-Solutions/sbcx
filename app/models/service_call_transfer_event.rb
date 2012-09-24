# == Schema Information
#
# Table name: events
#
#  id             :integer         not null, primary key
#  name           :string(255)
#  type           :string(255)
#  description    :string(255)
#  eventable_type :string(255)
#  eventable_id   :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  user_id        :integer
#  reference_id   :integer
#

class ServiceCallTransferEvent < Event

  def init
    self.name         = "Transferred Service Call"
    self.description  = "THE TRANSFER DESCRIPTION"
    self.reference_id = 2
  end

  def process_event
    Rails.logger.debug { "Running ServiceCallTransferEvent process" }

    service_call                      = associated_object
    service_call.subcontractor_status = ServiceCall::SUBCON_STATUS_TRANSFERRED
    service_call.save!

    new_service_call = TransferredServiceCall.new

    new_service_call.organization = service_call.subcontractor.becomes(Organization)
    new_service_call.provider     = service_call.organization.becomes(Provider)
    new_service_call.customer     = service_call.customer
    new_service_call.ref_id       = service_call.ref_id
    new_service_call.save!

    Rails.logger.debug { "created new service call after transfer: #{new_service_call.inspect}" }
    new_service_call

  end


end
