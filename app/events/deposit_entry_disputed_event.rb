class DepositEntryDisputedEvent < EntryEvent

  def init
    self.name         = I18n.t('entry_disputed_event.name')
    self.description  = I18n.t('entry_disputed_event.description')
    self.reference_id = 300012
  end

  def notification_class
    EntryDisputedNotification
  end

  def notification_recipients
    User.my_admins(entry.account.organization_id)
  end

  def process_event
    entry.disputed!(:state_only) unless triggering_event.nil?
    entry.ticket.deposit_disputed_prov_collection! if entry.ticket.can_deposit_disputed_prov_collection?
    super
  end

end
