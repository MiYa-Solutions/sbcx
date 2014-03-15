require 'hstore_amount'
require 'collectible'
class ScCollectedByEmployeeEvent < ServiceCallEvent
  include HstoreAmount

  setup_hstore_attr 'collector_id'
  setup_hstore_attr 'collector_type'
  include Collectible

  def init
    self.name         = I18n.t('sc_collected_by_employee_event.name')
    self.description  = I18n.t('sc_collected_by_employee_event.description', employee: collector_name)
    self.reference_id = 100045
  end

  def notification_recipients
    nil
  end

  def update_subcontractor
    subcon_service_call.events << ScProviderCollectedEvent.new(triggering_event: self,
                                                               amount:           self.amount,
                                                               collector:        service_call.organization,
                                                               payment_type:     self.payment_type)
  end

  def update_provider
    prov_service_call.events << ScCollectedEvent.new(triggering_event: self,
                                                     amount:           self.amount,
                                                     collector:        service_call.organization,
                                                     payment_type:     self.payment_type)
  end

  def process_event
    set_customer_account_as_paid collector: the_collector
    AffiliateBillingService.new(self).execute unless service_call.counterparty.nil?
    super
    #todo invoke employee billing service
  end

  private

  def the_collector
    if service_call.instance_of?(TransferredServiceCall) && service_call.provider.member?
      collector.organization
    else
      collector
    end
  end

end
