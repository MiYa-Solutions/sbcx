class AccAdjCancelEvent < AdjustmentEvent

  def init
    self.name         = I18n.t('acc_adj_cancel_event.name')
    self.description  = I18n.t('acc_adj_cancel_event.description', entry_id: self.entry_id)
    self.reference_id = 300006
  end

  def process_event
    affiliate_account.events << AccAdjCanceledEvent.new(entry_id: affiliate_entry_id, triggering_event: self)
    account.adjustment_canceled(entry)
  end

end
