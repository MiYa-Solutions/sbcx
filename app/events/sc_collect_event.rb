class ScCollectEvent < CollectionEvent
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
    CustomerBillingService.new(self).execute if service_call.organization.my_customer?(service_call.customer)
    AffiliateBillingService.new(self).execute if affiliate_involved?
    service_call.collected_prov_collection if update_provider_collection?
    super
  end

  private

  def affiliate_involved?
    service_call.transferred? || service_call.kind_of?(TransferredServiceCall)
  end

  def update_provider_collection?
    service_call.kind_of?(TransferredServiceCall) && service_call.can_collected_prov_collection?
  end

end
