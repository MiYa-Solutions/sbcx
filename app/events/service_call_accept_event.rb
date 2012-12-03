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

class ServiceCallAcceptEvent < ServiceCallEvent

  def init
    self.name         = I18n.t('service_call_accept_event.name')
    self.description  = I18n.t('service_call_accept_event.description')
    self.reference_id = 3
  end

  def notification_recipients
    nil
  end

  def notification_class
    nil
  end

  def update_provider
    prov_service_call = ServiceCall.find_by_ref_id_and_organization_id(service_call.ref_id, service_call.provider_id)

    prov_service_call.events << ServiceCallAcceptedEvent.new
    prov_service_call.accept_subcon

  end


end
