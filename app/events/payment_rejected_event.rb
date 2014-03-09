class PaymentRejectedEvent < PaymentEvent

  def init
    self.name         = I18n.t('payment_rejected_event.name')
    self.description  = I18n.t('payment_rejected_event.description')
    self.reference_id = 300010
  end

  def process_event
    update_account_balance
    ticket.reject_payment! if ticket.can_reject_payment?
  end

  private

  def update_account_balance
    rev_entry = RejectedPayment.new(event:       self,
                                    ticket:      payment.ticket,
                                    agreement:   payment.agreement,
                                    amount:      -payment.amount,
                                    description: I18n.t('payment_rejected_event.entry.description'))
    payment.account.entries << rev_entry
  end

end
