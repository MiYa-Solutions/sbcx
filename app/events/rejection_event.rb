class RejectionEvent < PaymentEvent


  protected

  def update_account_balance
    rev_entry = RejectedPayment.new(event:       self,
                                    status:      AccountingEntry::STATUS_CLEARED,
                                    ticket:      payment.ticket,
                                    agreement:   payment.agreement,
                                    amount:      -payment.amount,
                                    description: I18n.t('aff_payment_rejected_event.entry.description', payment_id: payment.id, payment_type: payment.name))
    payment.account.entries << rev_entry
  end
end
