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
    update_account_balance
  end

  private

  def update_account_balance
    account = entry.account
    Account.transaction do
      account.balance = account.balance - entry.amount
      if entry.account.can_un_synch?
        account.un_synch!
      else
        account.save!
      end
    end
  end

end
