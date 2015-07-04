class AffPaymentDisputedEvent < EntryEvent

  def init
    self.name         = I18n.t('aff_entry_disputed_event.name')
    self.description  = I18n.t('aff_entry_disputed_event.description')
    self.reference_id = 300023
  end

  def notification_class
    AffPaymentDisputedNotification
  end

  def process_event
    entry.disputed!(:state_only) unless triggering_event.nil?
    entry.dispute_affiliate_status

    if triggering_event && notification_recipients
      notify notification_recipients, notification_class
    end
  end

end
