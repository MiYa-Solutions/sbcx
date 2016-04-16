class ScCollectEvent < CollectionEvent
  include MoneyRails::ActionViewExtension

  def init
    self.name         = I18n.t('service_call_collect_event.name')
    self.description  = I18n.t('service_call_collect_event.description', collector: collector.name, amount: humanized_money_with_symbol(amount), type: payment_type)
    self.reference_id = 100023
  end

  def notification_recipients
    nil
  end

  def notification_class
    nil
  end

  def update_provider
    ActiveSupport::Deprecation.silence do
      prov_service_call.events << ScCollectedEvent.new(triggering_event: self,
                                                       amount:           self.amount,
                                                       collector:        service_call.organization,
                                                       payment_type:     self.payment_type)
    end
  end

  def update_subcontractor
    subcon_service_call.events << ScProviderCollectedEvent.new(triggering_event: self, amount: self.amount, collector: service_call.organization, payment_type: payment_type)
  end

  def process_event
    AffiliateBillingService.new(self).execute if affiliate_involved?
    CustomerBillingService.new(self).execute if service_call.organization.my_customer?(service_call.customer)
    service_call.collected_prov_collection if update_provider_collection?
    service_call.collected_subcon_collection if update_subcon_collection?
    super
  end

  private

  def affiliate_involved?
    service_call.transferred? || service_call.kind_of?(TransferredServiceCall)
  end

  def update_provider_collection?
    service_call.kind_of?(TransferredServiceCall) && service_call.can_collected_prov_collection?
  end

  def update_subcon_collection?
    service_call.respond_to?(:can_collected_subcon_collection?) &&
        service_call.can_collected_subcon_collection? &&
        (collector.becomes(Organization) == service_call.subcontractor.becomes(Organization))
  end

end
