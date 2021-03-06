class ScDepositConfirmedEvent < ServiceCallEvent

  def init
    self.name         = I18n.t('service_call_deposit_confirmed_event.name')
    self.description  = I18n.t('service_call_deposit_confirmed_event.description', provider: service_call.provider.name)
    self.reference_id = 100026
  end

  def notification_class
    ScDepositConfirmedNotification
  end

  def process_event
    update_accounting_entry
    service_call.prov_confirmed_deposit_payment
    super
  end

  private

  def update_accounting_entry
    type = case service_call.payment_type
             when 'cash'
               CashDepositToProvider
             when 'cheque'
               ChequeDepositToProvider
             when 'credit_card'
               CreditCardDepositToProvider
             when 'amex_credit_card'
               AmexDepositToProvider
             else
               raise "#{self.class.name}: Unexpected payment type (#{service_call.payment_type}) when processing the event"
           end

    deposit_event = entry.ticket.events.where("properties @> hstore(?, ?)", 'deposit_entry_id', entry.id.to_s).first
    deposit_event.entry.clear!
  end


end
