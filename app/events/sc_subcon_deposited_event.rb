class ScSubconDepositedEvent < ServiceCallEvent

  def init

    self.name         = I18n.t('service_call_subcon_deposited_event.name')
    self.description  = I18n.t('service_call_subcon_deposited_event.description', subcontractor: service_call.subcontractor.name)
    self.reference_id = 100021

  end

  def notification_recipients
    User.my_admins(service_call.organization.id)
  end

  def notification_class
    ScSubconDepositedNotification
  end

  def update_provider
    nil
  end

  def process_event
    update_subcon_account
    service_call.subcon_deposited_payment
    super
  end

  private

  def update_subcon_account
    account = Account.for_affiliate(service_call.organization, service_call.subcontractor).lock(true).first

    props = { amount:      service_call.total_price + service_call.tax_amount,
              ticket:      service_call,
              event:       self,
              agreement:   service_call.subcon_agreement,
              description: I18n.t("payment.#{service_call.payment_type}.description", ticket: service_call.id).html_safe }


    case service_call.payment_type
      when 'cash'
        entry = CashDepositFromSubcon.new(props)
      when 'credit_card'
        entry = CreditCardDepositFromSubcon.new(props)
      when 'amex_credit_card'
        entry = AmexDepositFromSubcon.new(props)
      when 'cheque'
        entry = ChequeDepositFromSubcon.new(props)
      else
        raise "#{self.class.name}: Unexpected payment type (#{service_call.payment_type}) when processing the event"
    end

    account.entries << entry
    entry.deposit


  end


end
