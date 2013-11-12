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

class ServiceCallTransferEvent < ServiceCallEvent

  def init
    self.name = I18n.t('service_call_transfer_event.name')
    self.description = I18n.t('service_call_transfer_event.description', subcontractor_name: service_call.subcontractor.name) if description.nil?
    self.reference_id = 100017
  end


  def process_event
    Rails.logger.debug { "Running ServiceCallTransferEvent process" }

    # create a service call copy for the subcontractor only if it is a member
    if service_call.subcontractor.subcontrax_member?

      new_service_call = TransferredServiceCall.new

      new_service_call.organization = service_call.subcontractor.becomes(Organization)
      new_service_call.provider     = service_call.organization.becomes(Provider)
      new_service_call.customer     = service_call.customer
      new_service_call.ref_id       = service_call.ref_id

      new_service_call.company      = service_call.company
      new_service_call.address1     = service_call.address1
      new_service_call.address2     = service_call.address2
      new_service_call.city         = service_call.city
      new_service_call.state        = service_call.state
      new_service_call.zip          = service_call.zip
      new_service_call.country      = service_call.country
      new_service_call.phone        = service_call.phone
      new_service_call.mobile_phone = service_call.mobile_phone
      new_service_call.work_phone   = service_call.work_phone
      new_service_call.email        = service_call.email


      new_service_call.transferable       = service_call.re_transfer
      new_service_call.allow_collection   = service_call.allow_collection
      new_service_call.name               = service_call.name
      new_service_call.notes              = service_call.notes
      new_service_call.provider_agreement = service_call.subcon_agreement
      new_service_call.properties         = create_transfer_props(service_call)
      new_service_call.events << ServiceCallReceivedEvent.new(triggering_event: self, description: I18n.t('service_call_received_event.description', name: service_call.organization.name))

      new_service_call.save!
      Rails.logger.debug { "created new service call after transfer: #{new_service_call.inspect}" }


    end

    new_service_call

  end

  def notification_recipients
    nil
  end

  def notification_class
    nil
  end

  private

  def create_transfer_props(job)
    result = {}

    result = result.merge('provider_fee' => job.properties['subcon_fee']) if job.properties['subcon_fee']
    result = result.merge('bom_reimbursement' => job.properties['bom_reimbursement']) if job.properties['bom_reimbursement']

    result
  end

end
