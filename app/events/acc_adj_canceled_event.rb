class AccAdjCanceledEvent < AdjustmentEvent

  def init
    self.name         = I18n.t('acc_adj_canceled_event.name')
    self.description  = I18n.t('acc_adj_canceled_event.description', entry_id: entry_id, aff: affiliate.name)
    self.reference_id = 300007
  end

  def process_event
    entry.cancel!
    account.adjustment_canceled(entry)
  end

end
