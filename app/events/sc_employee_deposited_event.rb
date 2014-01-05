class ScEmployeeDepositedEvent < ServiceCallEvent

  def init
    self.name         = I18n.t('sc_employee_deposited_event.name')
    self.description  = I18n.t('sc_employee_deposited_event.description', employee: service_call.collector.name)
    self.reference_id = 100046
  end

  def process_event

  end

end
