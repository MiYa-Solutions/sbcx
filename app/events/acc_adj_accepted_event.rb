class AccAdjAcceptedEvent < AdjustmentEvent

  def init
    self.name         = I18n.t('acc_adj_accepted_event.name')
    self.description  = I18n.t('acc_adj_accepted_event.description', entry_id: entry_id, aff: affiliate.name)
    self.reference_id = 300003
  end

  def process_event
    entry.accept!
    account.adjustment_accepted
  end

end
