class ScCollectedByEmployeeEvent < ServiceCallEvent

  def init
    self.name         = I18n.t('sc_collected_by_employee_event.name')
    self.description  = I18n.t('sc_collected_by_employee_event.description', employee: service_call.collector.name)
    self.reference_id = 100045
  end

  def process_event
    #todo invoke employee billing service
  end

end
