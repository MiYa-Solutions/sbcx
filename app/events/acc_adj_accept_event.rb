class AccAdjAcceptEvent < AdjustmentEvent

  def init
    self.name         = I18n.t('acc_adj_accept_event.name')
    self.description  = I18n.t('acc_adj_accept_event.description', aff: affiliate.name, entry_id: self.entry_id)
    self.reference_id = 300002
  end

  def process_event
    account.events << AccAdjAcceptedEvent.new(entry_id: orig_entry_id, triggering_event: self)
  end

  private

  def orig_entry_id
    AccountAdjustedEvent.where(eventable_id: account.id, eventable_type: 'Account').
        where("properties @> (entry_id => ?)", entry_id).
        first.
        orig_entry_id
  end

end
