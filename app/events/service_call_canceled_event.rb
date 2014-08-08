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
    self.reference_id = 100004
  end

  def update_provider
    prov_service_call.events << ServiceCallCanceledEvent.new(triggering_event: self)
    prov_service_call
  end

  def process_event
    CustomerBillingService.new(self).execute if service_call.work_done? && service_call.is_a?(MyServiceCall)
    service_call.cancel_payment! if service_call.is_a?(MyServiceCall) && service_call.can_cancel_payment?
    service_call.cancel_work!
    service_call.cancel_subcon_collection! if defined?(service_call.can_cancel_subcon_collection?) && service_call.can_cancel_subcon_collection?
    service_call.cancel_subcon!
    invoke_affiliate_billing
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
