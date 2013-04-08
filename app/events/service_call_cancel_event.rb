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
    User.my_dispatchers(service_call.organization.id)
  end

  def notification_class
    ScCancelNotification
  end

  def update_provider
    prov_service_call.events << ServiceCallCanceledEvent.new(triggering_event: self)
    prov_service_call
  end

  def process_event
    if service_call.is_a?(MyServiceCall)
    service_call.customer.account.entries << CanceledJobAdjustment.new(event: self,
                                                                       ticket: service_call,
                                                                       amount: - service_call.total_price,
                                                                       description: "Reimbursement for a canceled job")
    end
    invoke_affiliate_billing if service_call.work_done?
    super
  end

end
