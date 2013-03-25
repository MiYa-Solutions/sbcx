class ScConfirmDepositEvent < ServiceCallEvent

  def init
    self.name         = I18n.t('service_call_confirm_deposit_event.name')
    self.description  = I18n.t('service_call_confirm_deposit_event.description', subcontractor: service_call.subcontractor.name)
    self.reference_id = 100025
  end

  def notification_recipients
    nil
  end

  def notification_class
    ScConfirmDepositNotification
  end

  def update_subcontractor
    subcon_service_call.events << ScDepositConfirmedEvent.new(triggering_event: self)
  end

  def process_event
    update_accounting_entry
    super
  end

  private

  def update_accounting_entry
    type  = case service_call.payment_type
              when 'cash'
                CashDepositFromSubcon
              when 'cheque'
                ChequeDepositFromSubcon
              when 'credit_card'
                CreditCardDepositFromSubcon
              else
                raise "#{self.class.name}: Unexpected payment type (#{service_call.payment_type}) when processing the event"
            end

    entry = AccountingEntry.where(ticket_id: service_call.id, type: type).first

    entry.clear
  end


end
