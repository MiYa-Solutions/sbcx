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

class ServiceCallCancelEvent < ServiceCallEvent

  def init
    self.name = I18n.t('service_call_cancel_event.name') if name.nil?
    self.description = I18n.t('service_call_cancel_event.description', user: creator.name.rstrip) if description.nil?
    self.reference_id = 100003
  end

  def notification_recipients
    res = User.my_dispatchers(service_call.organization.id).all
    res << service_call.technician if service_call.technician.present?
    res
  end

  def notification_class
    ScCancelNotification
  end

  def update_provider
    prov_service_call.events << ServiceCallCanceledEvent.new(triggering_event: self)
    prov_service_call
  end

  def update_subcontractor
    subcon_service_call.events << ServiceCallCanceledEvent.new(triggering_event: self) unless subcon_service_call.canceled?
    subcon_service_call
  end

  def process_event
    CustomerBillingService.new(self).execute if service_call.work_done? && service_call.is_a?(MyServiceCall)
    service_call.cancel_payment! if service_call.is_a?(MyServiceCall) && service_call.can_cancel_payment?
    service_call.cancel_prov_collection! if service_call.kind_of?(TransferredServiceCall) && service_call.can_cancel_prov_collection?
    service_call.cancel_provider! if service_call.kind_of?(TransferredServiceCall) && service_call.can_cancel_provider?
    invoke_affiliate_billing
    super
  end

end
