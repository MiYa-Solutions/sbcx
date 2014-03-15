class DepositEntryDisputeEvent < EntryEvent

  def init
    self.name         = I18n.t('entry_dispute_event.name')
    self.description  = I18n.t('entry_dispute_event.description')
    self.reference_id = 300011
  end

  def process_event
    unless entry.matching_entry.nil?
      entry.matching_entry.ticket.events << DepositEntryDisputedEvent.new(entry_id: entry.matching_entry.id, triggering_event: self)
    end
    entry.ticket.deposit_disputed_subcon_collection! if entry.ticket.can_deposit_disputed_subcon_collection?
  end

end
