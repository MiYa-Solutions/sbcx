class AffPaymentConfirmedEvent < PaymentEvent

  def init
    self.name         = I18n.t('aff_entry_confirmed_event.name')
    self.description  = I18n.t('aff_entry_confirmed_event.description')
    self.reference_id = 300021
  end

  def notification_class
    AffPaymentConfirmedNotification
  end

  def process_event
    entry.confirmed!(:state_only) unless triggering_event.nil?
    entry.confirm_affiliate_status

    if triggering_event && notification_recipients
      notify notification_recipients, notification_class
    end
  end

end
