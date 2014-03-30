require 'hstore_amount'
require 'collectible'
class ScProviderCollectedEvent < ServiceCallEvent
  include HstoreAmount

  setup_hstore_attr 'collector_id'
  setup_hstore_attr 'collector_type'
  include Collectible

  def init
    self.name         = I18n.t('service_call_provider_collected_event.name')
    self.description  = I18n.t('service_call_provider_collected_event.description', provider: service_call.provider.name)
    self.reference_id = 100027
  end

  def notification_recipients
    nil
  end

  def notification_class
    ScProviderCollectedNotification
  end

  def update_subcontractor
    subcon_service_call.events << ScProviderCollectedEvent.new(triggering_event: self) if subcon_service_call.allow_collection?
  end

  def process_event
    service_call.collector = service_call.provider

    if self.triggering_event.present?
      service_call.payment_type = self.triggering_event.payment_type
    end

    AffiliateBillingService.new(self).execute
    service_call.collected_prov_collection
    super
  end


end
