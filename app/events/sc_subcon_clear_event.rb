class ScSubconClearEvent < ServiceCallEvent

  def init
    self.name         = I18n.t('service_call_subcon_clear_event.name', subcon: service_call.subcontractor.name)
    self.description  = I18n.t('service_call_subcon_clear_event.description', subcon: service_call.subcontractor.name)
    self.reference_id = 100041
  end

  def notification_recipients
    nil
  end

  def notification_class
    nil
  end


end
