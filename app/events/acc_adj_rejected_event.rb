class AccAdjRejectedEvent < AdjustmentEvent

  def init
    self.name         = I18n.t('acc_adj_rejected_event.name')
    self.description  = I18n.t('acc_adj_rejected_event.description', entry_id: entry_id, aff: affiliate.name)
    self.reference_id = 300005
  end

  def process_event
    entry.reject!
    account.adjustment_rejected
  end

end
