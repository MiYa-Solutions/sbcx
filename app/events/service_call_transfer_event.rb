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
    self.name         = I18n.t('service_call_transfer_event.name')
    self.reference_id = 2
  end


  def process_event
    Rails.logger.debug { "Running ServiceCallTransferEvent process" }
    service_call = associated_object

    # create a service call copy for the subcontractor only if it is a member
    if service_call.subcontractor.subcontrax_member

      new_service_call = TransferredServiceCall.new

      new_service_call.organization = service_call.subcontractor.becomes(Organization)
      new_service_call.provider     = service_call.provider
      new_service_call.customer     = service_call.customer
      new_service_call.ref_id       = service_call.ref_id

      #self.description = I18n.t('service_call_transfer_event.description', subcontractor_name: service_call.subcontractor.name) if description.nil?
      self.save!
      new_service_call.save!
    end


    Rails.logger.debug { "created new service call after transfer: #{new_service_call.inspect}" }
    new_service_call

  end


end
