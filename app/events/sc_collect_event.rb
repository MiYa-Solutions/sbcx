require 'hstore_amount'
require 'collectible'
class ScCollectEvent < ServiceCallEvent
  include HstoreAmount

  setup_hstore_attr 'collector_id'
  setup_hstore_attr 'collector_type'
  include Collectible


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
    prov_service_call.events << ScCollectedEvent.new(triggering_event: self,
                                                     amount:           self.amount,
                                                     collector:        service_call.organization,
                                                     payment_type:     self.payment_type)
  end

  def update_subcontractor
    subcon_service_call.events << ScProviderCollectedEvent.new(triggering_event: self, amount: self.amount, collector: service_call.organization)
  end

  def process_event
    set_customer_account_as_paid collector: collector if service_call.provider.subcontrax_member?
    AffiliateBillingService.new(self).execute
    service_call.collect_prov_collection if service_call.can_collect_prov_collection?
    super
  end

end
