require 'hstore_amount'
class ScCollectEvent < ServiceCallEvent
  include HstoreAmount

  def init
    self.name         = I18n.t('service_call_collect_event.name')
    self.description  = I18n.t('service_call_collect_event.description')
    self.reference_id = 100023
  end

  def notification_recipients
    nil
  end

  def notification_class
    nil
  end

  def update_provider
    prov_service_call.events << ScCollectedEvent.new(triggering_event: self, amount: self.amount)
  end

  def process_event
    set_customer_account_as_paid if service_call.provider.subcontrax_member?
    AffiliateBillingService.new(self).execute
    super
  end

  private

  #def update_provider_account
  #  account = Account.for_affiliate(service_call.organization, service_call.provider).lock(true).first
  #  props = { amount:      service_call.total_price,
  #            ticket:      service_call,
  #            event:       self,
  #            description: I18n.t("payment.#{service_call.payment_type}.description", ticket: service_call.id).html_safe }
  #
  #  case service_call.payment_type
  #    when 'cash'
  #      entry =  CashCollectionForProvider.new(props)
  #    when 'credit_card'
  #      entry =  CreditCardCollectionForProvider.new(props)
  #    when 'cheque'
  #      entry =  ChequeCollectionForProvider.new(props)
  #    else
  #      raise "#{self.class.name}: Unexpected payment type (#{service_call.payment_type}) when processing the event"
  #  end
  #
  #  account.entries << entry
  #  entry.clear
  #
  #end


end
