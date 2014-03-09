require 'hstore_amount'
require 'collectible'
class ScCollectedEvent < ServiceCallEvent
  include HstoreAmount

  setup_hstore_attr 'collector_id'
  setup_hstore_attr 'collector_type'
  include Collectible


  def init
    self.name         = I18n.t('service_call_collected_event.name')
    self.description  = I18n.t('service_call_collected_event.description', collector: collector.name)
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
    update_customer_bill
    update_affiliate_bill
    update_statuses
    super
  end

  private

  def update_customer_bill
    service_call.collector    ||= service_call.subcontractor
    service_call.payment_type ||= triggering_event.eventable.payment_type
    CustomerBillingService.new(self).execute if service_call.organization.my_customer?(service_call.customer)
  end

  def update_affiliate_bill
    AffiliateBillingService.new(self).execute
  end

  def update_statuses
    service_call.collect_payment!(:state_only)
    service_call.collected_subcon_collection if service_call.can_collected_subcon_collection?
  end


end
