require 'hstore_amount'
class ServiceCallPaidEvent < ServiceCallEvent
  include HstoreAmount

  def init
    self.name         = I18n.t('service_call_paid_event.name')
    self.description  = I18n.t('service_call_paid_event.description')
    self.reference_id = 100009
  end

  def update_subcontractor
    subcon_service_call.events << ScProviderCollectedEvent.new(triggering_event: self) if subcon_service_call.allow_collection?
  end

  def notification_recipients
    User.my_admins(service_call.organization.id)
  end

  def notification_class
    ScPaidNotification
  end

  def process_event
    set_customer_account_as_paid
    AffiliateBillingService.new(self).execute if service_call.instance_of?(TransferredServiceCall) || service_call.transferred?
    super
  end

  private

  #def amount_currency
  #  properties['amount_currency'] || 'USD'
  #end

  def amount_cents
    properties['amount_cents'] || 0.0
  end


end