class ScClearCustomerPaymentEvent < ServiceCallEvent

  def init
    self.name         = I18n.t('service_call_clear_customer_payment_event.name')
    self.description  = I18n.t('service_call_clear_customer_payment_event.description')
    self.reference_id = 100034
  end

  def notification_recipients
    nil
  end

  def notification_class
    nil
  end

  def process_event
    update_accounting_entries
    super
  end

  private

  def update_accounting_entries
    type  = case service_call.payment_type
              when 'cash'
                CashPayment
              when 'cheque'
                ChequePayment
              when 'credit_card'
                CreditPayment
              else
                raise "#{self.class.name}: Unexpected payment type (#{service_call.payment_type}) when processing the event"
            end

    entry = AccountingEntry.where(ticket_id: service_call.id, type: type).lock(true).first

    entry.clear
  end
end
