class DepositEntryConfirmedEvent < EntryEvent

  def init
    self.name         = I18n.t('entry_confirmed_event.name')
    self.description  = I18n.t('entry_confirmed_event.description')
    self.reference_id = 300014
  end

  def notification_class
    ScDepositConfirmedNotification
  end

  def process_event
    entry.confirmed!(:state_only) unless triggering_event.nil?
    entry.ticket.confirmed_prov_collection! if entry.ticket.can_confirmed_prov_collection?
    clear_collection_entry

    if triggering_event && notification_recipients
      notify notification_recipients, notification_class
    end
  end

end
