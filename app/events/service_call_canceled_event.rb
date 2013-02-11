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


class ServiceCallCanceledEvent < ServiceCallEvent

  def init
    self.name = I18n.t('service_call_cancel_event.name') if name.nil?
    self.description = I18n.t('service_call_canceled_event.description', subcontractor: service_call.subcontractor.name) if description.nil?
    self.reference_id = 9
  end

  def update_provider
    prov_service_call.events << ServiceCallCanceledEvent.new(triggering_event: self)
    prov_service_call
  end

  def process_event
    service_call.cancel
    super
  end

  def notification_recipients
    User.my_dispatchers(service_call.organization.id)
  end

  def notification_class
    ScCanceledNotification
  end


end
