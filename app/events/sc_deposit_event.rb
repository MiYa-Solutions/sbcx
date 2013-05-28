class ScDepositEvent < ServiceCallEvent

  def init
    self.name         = I18n.t('service_call_deposit_event.name')
    self.description  = I18n.t('service_call_deposit_event.description', provider: service_call.provider.name)
    self.reference_id = 100022
  end

  def notification_recipients
    nil
  end

  def notification_class
    nil
  end

  def update_provider
    prov_service_call.events << ScSubconDepositedEvent.new(triggering_event: self)
  end

  def process_event
    update_provider_account
    super
  end

  private

  def update_provider_account
    account = Account.for_affiliate(service_call.organization, service_call.provider).lock(true).first
    props = { amount:      service_call.total_price,
              ticket:      service_call,
              event:       self,
              description: I18n.t("payment.#{service_call.payment_type}.description", ticket: service_call.id).html_safe }

    case service_call.payment_type
      when 'cash'
        entry = CashDepositToProvider.new(props)
      when 'credit_card'
        entry = CreditCardDepositToProvider.new(props)
      when 'amex_credit_card'
        entry = AmexDepositToProvider.new(props)
      when 'cheque'
        entry = ChequeDepositToProvider.new(props)
      else
        raise "#{self.class.name}: Unexpected payment type (#{service_call.payment_type}) when processing the event"
    end

    account.entries << entry
    entry.deposit


  end


end
