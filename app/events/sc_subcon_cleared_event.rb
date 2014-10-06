class ScSubconClearedEvent < ScSettlementEvent

  def init

    self.name         = I18n.t('service_call_subcon_cleared_event.name')
    self.description  = I18n.t('service_call_subcon_cleared_event.description', subcon: service_call.subcontractor.name, payment_type: service_call.subcon_payment.classify.constantize.model_name.human, ref: service_call.ref_id)
    self.reference_id = 100040
  end

  def notification_class
    ScSubconClearedNotification
  end

  def process_event
    service_call.clear_subcon
    clear_accounting_entries
    super
  end


end
