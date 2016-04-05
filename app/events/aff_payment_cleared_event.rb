class AffPaymentClearedEvent < PaymentEvent

  def init
    self.name         = I18n.t('aff_payment_cleared_event.name')
    self.description  = I18n.t('aff_payment_cleared_event.description')
    self.reference_id = 300018
  end

  def process_event
    payment.cleared(:state_only) if triggering_event
    ticket.clear_subcon! if ticket.can_clear_subcon?
    super
  end

  def notification_class
    AffPaymentClearedNotification
  end

end
