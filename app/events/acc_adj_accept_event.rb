class AccAdjAcceptEvent < AdjustmentEvent

  def init
    self.name         = I18n.t('acc_adj_accept_event.name')
    self.description  = I18n.t('acc_adj_accept_event.description', aff: affiliate.name, entry_id: self.entry_id)
    self.reference_id = 300002
  end

  def process_event
    affiliate_account.events << AccAdjAcceptedEvent.new(entry_id: affiliate_entry_id, triggering_event: self)
  end

end
