class ScCollectedEvent < CollectionEvent

  def init
    self.name         = I18n.t('service_call_collected_event.name')
    self.description  = I18n.t('service_call_collected_event.description', collector: collector.name)
    self.reference_id = 100024
  end

  def notification_class
    ScCollectedNotification
  end

  def update_provider
    ActiveSupport::Deprecation.silence do
      prov_service_call.events << ScCollectedEvent.new(triggering_event: self,
                                                       amount:           self.amount,
                                                       collector:        service_call.organization,
                                                       payment_type:     self.payment_type)
    end
  end

  def process_event
    update_affiliate_bill
    update_customer_bill
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
    service_call.collect_payment!(:state_only) if service_call.can_collect_payment?
    service_call.collected_subcon_collection if service_call.can_collected_subcon_collection?
    service_call.collected_prov_collection if service_call.kind_of?(TransferredServiceCall) && service_call.can_collected_prov_collection?
  end


end
