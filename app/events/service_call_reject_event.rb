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

class ServiceCallRejectEvent < Event

  def init
    self.name         = "Reject Service Call"
    self.description  = "Service rejected by subcontractor"
    self.reference_id = 4
  end

  def process_event
    Rails.logger.debug { "Running ServiceCallRejectEvent process" }

    service_call = associated_object

    prov_service_call = ServiceCall.find_by_ref_id_and_organization_id(service_call.ref_id, service_call.provider_id)
    prov_service_call.subcon_reject_subcon

    prov_service_call

  end


end
