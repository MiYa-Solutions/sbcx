class AccountAdjustedEvent < AdjustmentEvent

  setup_hstore_attr 'orig_entry_id'

  alias_method :account, :eventable

  def init
    self.name         = I18n.t('account_adjusted_event.name')
    self.description  = I18n.t('account_adjusted_event.description')
    self.reference_id = 300001
  end

  def process_event
    new_entry = ReceivedAdjEntry.new(amount:        orig_entry.amount,
                                     description:   orig_entry.description,
                                     ticket:        ticket,
                                     ticket_ref_id: orig_entry.ticket_ref_id,
                                     event:         self)
    account.entries << new_entry
    self.entry_id      = new_entry.id
    self.orig_entry_id = orig_entry.id
    self.save!
  end

  private

  def orig_entry
    AccountingEntry.find(self.triggering_event.entry_id)
  end

  def new_adj_entry
    @new_adj_entry ||= ReceivedAdjEntry.new(amount: orig_entry.amount)
  end

  def ticket
    Ticket.find_by_organization_id_and_ref_id(account.organization_id, orig_entry.ticket.ref_id)
  end

end
