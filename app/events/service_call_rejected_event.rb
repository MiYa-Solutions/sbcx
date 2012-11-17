class ServiceCallRejectedEvent < Event
  def init
    self.name         = I18n.t('service_call_rejected_event.name')
    self.reference_id = 12
  end

  def process_event

  end
end