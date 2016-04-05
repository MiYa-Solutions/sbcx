class AffPaymentRejectedEvent < RejectionEvent

  def init
    self.name         = I18n.t('aff_payment_rejected_event.name')
    self.description  = I18n.t('aff_payment_rejected_event.description', payment_id: payment.id, payment_type: payment.name)
    self.reference_id = 300019
  end

  def process_event
    Account.transaction do
      ticket.reject_subcon! if ticket.can_reject_subcon?
      payment.rejected!(:state_only) if payment.can_rejected?
      update_account_balance
    end
    super
  end

  def notification_class
    AffPaymentRejectedNotification
  end


end
