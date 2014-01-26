require 'hstore_amount'
require 'collectible'
class ScCollectedEvent < ServiceCallEvent
  include HstoreAmount

  setup_hstore_attr 'collector_id'
  setup_hstore_attr 'collector_type'
  include Collectible


  def init
    self.name         = I18n.t('service_call_collected_event.name')
    self.description  = I18n.t('service_call_collected_event.description', subcontractor: service_call.subcontractor.name)
    self.reference_id = 100024
  end

  def notification_recipients
    User.my_admins(service_call.organization_id)
  end

  def notification_class
    ScCollectedNotification
  end

  def update_provider
    prov_service_call.events << ScCollectedEvent.new(triggering_event: self)
  end

  def process_event
    service_call.collector    ||= service_call.subcontractor
    service_call.payment_type ||= triggering_event.eventable.payment_type
    AffiliateBillingService.new(self).execute

    # pass a :state_only argument to the observer indicating that only a state transition should be performed
    service_call.subcon_collected_payment(:state_only) if service_call.can_subcon_collected_payment?
    super
  end

  private

  #def update_subcon_account
  #  account = Account.for_affiliate(service_call.organization, service_call.subcontractor).lock(true).first
  #
  #  props = { amount:      service_call.total_price,
  #            ticket:      service_call,
  #            event:       self,
  #            description: I18n.t("payment.#{service_call.payment_type}.description", ticket: service_call.id).html_safe }
  #
  #
  #  case service_call.payment_type
  #    when 'cash'
  #      entry =  CashCollectionFromSubcon.new(props)
  #    when 'credit_card'
  #      entry =  CreditCardCollectionFromSubcon.new(props)
  #    when 'cheque'
  #      entry =  ChequeCollectionFromSubcon.new(props)
  #    else
  #      raise "#{self.class.name}: Unexpected payment type (#{service_call.payment_type}) when processing the event"
  #  end
  #
  #  account.entries << entry
  #  entry.clear
  #
  #
  #
  #end


end
