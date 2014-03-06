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
    CustomerBillingService.new(self).execute if service_call.organization.my_customer?(service_call.customer)
    service_call.collect_payment!(:state_only)
    AffiliateBillingService.new(self).execute
    service_call.collected_subcon_collection if service_call.can_collected_subcon_collection?
    super
  end

end
