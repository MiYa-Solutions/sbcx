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
      Ticket.transaction do
        new_service_call.save!
        copy_boms_to_subcon

      end
      new_service_call.events << ServiceCallReceivedEvent.new(triggering_event: self, description: I18n.t('service_call_received_event.description', name: service_call.organization.name))
      Rails.logger.debug { "created new service call after transfer: #{new_service_call.inspect}" }
      new_service_call
    end
    set_subcon_statuses_for_prov
    reset_job_status

  end

  def notification_recipients
    nil
  end

  def notification_class
    nil
  end

  private

  def new_service_call
    @subcon_ticket ||= generate_new_subcon_job
  end

  def generate_new_subcon_job
    new_obj = SubconServiceCall.new

    new_obj.prov_collection_status = CollectionStateMachine::STATUS_PENDING

    new_obj.organization = service_call.subcontractor.becomes(Organization)
    new_obj.provider     = service_call.organization.becomes(Provider)
    new_obj.customer     = service_call.customer
    new_obj.ref_id       = service_call.ref_id

    new_obj.company       = service_call.company
    new_obj.address1      = service_call.address1
    new_obj.address2      = service_call.address2
    new_obj.city          = service_call.city
    new_obj.state         = service_call.state
    new_obj.zip           = service_call.zip
    new_obj.country       = service_call.country
    new_obj.phone         = service_call.phone
    new_obj.mobile_phone  = service_call.mobile_phone
    new_obj.work_phone    = service_call.work_phone
    new_obj.email         = service_call.email
    new_obj.scheduled_for = service_call.scheduled_for


    new_obj.transferable       = service_call.re_transfer
    new_obj.allow_collection   = service_call.allow_collection
    new_obj.name               = service_call.name
    new_obj.notes              = service_call.notes
    new_obj.provider_agreement = service_call.subcon_agreement
    new_obj.properties         = create_transfer_props(service_call)
    new_obj.tax                = service_call.tax
    new_obj

  end

  def create_transfer_props(job)
    result = {}

    result = result.merge('provider_fee' => job.properties['subcon_fee']) if job.properties['subcon_fee']
    result = result.merge('prov_bom_reimbursement' => job.properties['bom_reimbursement']) if job.properties['bom_reimbursement']

    result
  end

  def copy_boms_to_subcon
    service_call.boms.each do |bom|
      BomSynchService.new(bom).synch
    end
  end

  def set_subcon_statuses_for_prov
    service_call.subcontractor_status     = ServiceCall::SUBCON_STATUS_PENDING
    service_call.subcon_collection_status = CollectionStateMachine::STATUS_PENDING
    service_call.save!
  end

  def reset_job_status
    service_call.reset_work! if service_call.can_reset_work?
  end


end
