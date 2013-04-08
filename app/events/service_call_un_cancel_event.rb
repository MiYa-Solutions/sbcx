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

class ServiceCallUnCancelEvent < ServiceCallEvent

  def init
    self.name = I18n.t('service_call_un_cancel_event.name') if name.nil?
    self.description = I18n.t('service_call_un_cancel_event.description', user: creator.name.rstrip) if description.nil?
    self.reference_id = 100037
  end

  def notification_recipients
    nil
  end

  def notification_class
    nil
  end

  def update_provider
    prov_service_call.events << ServiceCallUnCanceledEvent.new(triggering_event: self)
    prov_service_call
  end

end
