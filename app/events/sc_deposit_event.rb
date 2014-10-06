require 'hstore_amount'
class ScDepositEvent < ServiceCallEvent
  include HstoreAmount

  setup_hstore_attr 'entry_id'
  setup_hstore_attr 'deposit_entry_id'

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
    prov_service_call.events << ScSubconDepositedEvent.new(triggering_event: self,entry_id: entry.matching_entry.id)
  end

  def process_event
    update_provider_account
    update_statuses
    super
  end

  def entry
    @entry ||= AccountingEntry.find entry_id
  end


  private

  # todo refactor to an entry factory
  def update_provider_account
    account = Account.for_affiliate(service_call.organization, service_call.provider).lock(true).first
    props   = { amount:      amount,
                ticket:      service_call,
                event:       self,
                agreement:   service_call.provider_agreement,
                description: I18n.t("payment.#{service_call.payment_type}.description", ticket: service_call.id).html_safe }

    case entry.class.name
      when CashCollectionForProvider.name
        deposit_entry = CashDepositToProvider.new(props)
      when CreditCardCollectionForProvider.name
        deposit_entry = CreditCardDepositToProvider.new(props)
      when AmexCollectionForProvider.name
        deposit_entry = AmexDepositToProvider.new(props)
      when ChequeCollectionForProvider.name
        deposit_entry = ChequeDepositToProvider.new(props)
      else
        raise "#{self.class.name}: Unexpected payment type (#{service_call.payment_type}) when processing the event"
    end

    account.entries << deposit_entry
    self.deposit_entry_id = deposit_entry.id
    self.save!
  end

  def update_statuses
    service_call.deposited_prov_collection! if service_call.can_deposited_prov_collection?
  end


end
