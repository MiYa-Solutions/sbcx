require 'hstore_setup_methods'
class ScSubconDepositedEvent < ServiceCallEvent
  extend HstoreSetupMethods

  setup_hstore_attr 'entry_id'

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
    entry.deposited!(:transition_only)
    super
  end

  private

  def update_subcon_account
    account = Account.for_affiliate(service_call.organization, service_call.subcontractor).lock(true).first

    props = { amount:      entry.amount,
              ticket:      service_call,
              event:       self,
              agreement:   service_call.subcon_agreement,
              description: I18n.t("payment.#{service_call.payment_type}.description", ticket: service_call.id).html_safe }


    case entry.class.name
      when CashCollectionFromSubcon.name
        deposit_entry = CashDepositFromSubcon.new(props.update(matching_entry: matching_deposit_entry(CashDepositToProvider)))
      when CreditCardCollectionFromSubcon.name
        deposit_entry = CreditCardDepositFromSubcon.new(props.update(matching_entry: matching_deposit_entry(CreditCardDepositToProvider)))
      when AmexCollectionFromSubcon.name
        deposit_entry = AmexDepositFromSubcon.new(props.update(matching_entry: matching_deposit_entry(AmexDepositToProvider)))
      when ChequeCollectionFromSubcon.name
        deposit_entry = ChequeDepositFromSubcon.new(props.update(matching_entry: matching_deposit_entry(ChequeDepositToProvider)))
      else
        raise "#{self.class.name}: Unexpected payment type (#{service_call.payment_type}) when processing the event"
    end

    AccountingEntry.transaction do
      account.entries << deposit_entry
      if triggering_event
        deposit_entry.matching_entry.matching_entry = deposit_entry
        deposit_entry.matching_entry.matching_entry.save!
      end

    end

  end

  private
  def entry
    @entry ||= AccountingEntry.find entry_id
  end

  def matching_deposit_entry(klass)
    if triggering_event
      triggering_event.accounting_entries.where(type: klass).first
    end
  end


end
