class AccountAdjustedEvent < AdjustmentEvent

  setup_hstore_attr 'matching_entry_id'

  def init
    self.name         = I18n.t('account_adjusted_event.name')
    self.description  = I18n.t('account_adjusted_event.description')
    self.reference_id = 300001
  end

  def process_event
    create_the_matching_entry
    update_both_events_with_entry_ids

    triggering_event.save!
    self.save!
    account.adjustment_submitted

    notify User.my_admins(account.organization.id), AccountAdjustedNotification, entry
  end

  def affiliate_entry_id
    self.matching_entry_id
  end

  private

  def create_the_matching_entry
    new_entry = ReceivedAdjEntry.new(amount:        -orig_entry.amount,
                                     description:   orig_entry.description,
                                     ticket:        ticket,
                                     ticket_ref_id: orig_entry.ticket_ref_id,
                                     event:         self)
    account.entries << new_entry

    self.entry_id = new_entry.id

    new_entry

  end

  def update_both_events_with_entry_ids
    self.matching_entry_id             = orig_entry.id
    triggering_event.matching_entry_id = self.entry_id
  end

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
