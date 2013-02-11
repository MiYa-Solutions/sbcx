# == Schema Information
#
# Table name: events
#
#  id                  :integer         not null, primary key
#  name                :string(255)
#  type                :string(255)
#  description         :string(255)
#  eventable_type      :string(255)
#  eventable_id        :integer
#  created_at          :datetime        not null
#  updated_at          :datetime        not null
#  user_id             :integer
#  reference_id        :integer
#  creator_id          :integer
#  updater_id          :integer
#  triggering_event_id :integer
#

class ServiceCallEvent < Event
  def process_event

    Rails.logger.debug { "Running #{self.class.name} process_event method" }

    update_provider if notify_provider?

    notify notification_recipients, notification_class unless notification_recipients.nil?

  end

  def service_call
    @service_call ||= self.eventable
  end

  def notify_provider?
    service_call.provider.subcontrax_member? && service_call.provider.id != service_call.organization.id
  end

  def prov_service_call
    @prov_service_call ||= ServiceCall.find_by_ref_id_and_organization_id(service_call.ref_id, service_call.provider_id)
  end

  def copy_boms_to_provider
    service_call.boms.each do |bom|
      new_bom = bom.dup
      # if the material buyer is the subcontractor or the technician make the buyer the owner of this service call
      if new_bom.buyer.instance_of?(User) || new_bom.buyer == service_call.subcontractor
        new_bom.buyer = service_call.organization
      end
      prov_service_call.boms << new_bom
    end
  end

end
