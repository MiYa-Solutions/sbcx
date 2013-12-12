class AccAdjRejectEvent < AdjustmentEvent

  def init
    self.name         = I18n.t('acc_adj_reject_event.name')
    self.description  = I18n.t('acc_adj_reject_event.description', aff: affiliate.name, entry_id: self.entry_id)
    self.reference_id = 300004
  end

  def process_event
    affiliate_account.events << AccAdjRejectedEvent.new(entry_id: affiliate_entry_id, triggering_event: self)
  end


end
