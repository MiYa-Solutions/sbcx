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
    self.name = I18n.t('service_call_cancel_event.name')
    self.description = I18n.t('service_call_canceled_event.description', subcontractor: service_call.subcontractor.name)
    self.reference_id = 100004
  end

  def process_event
    service_call.cancel_work! if service_call.can_cancel_work?
    super
  end

  def notification_recipients
    res = User.my_dispatchers(service_call.organization.id).all
    res << service_call.technician unless service_call.technician.nil? || res.map(&:id).include?(service_call.technician.id)
    res
  end

  def notification_class
    ScCanceledNotification
  end


end
