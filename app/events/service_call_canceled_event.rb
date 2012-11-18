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


class ServiceCallCanceledEvent < Event

  def init
    self.name = I18n.t('service_call_cancel_event.name') if name.nil?
    self.description = I18n.t('service_call_cancel_event.description') if description.nil?
    self.reference_id = 9
  end

  def process_event
    Rails.logger.debug { "Running ServiceCallCancelEvent process" }

    service_call = associated_object

    service_call.cancel_subcon

  end


end
