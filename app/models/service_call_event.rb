# == Schema Information
#
# Table name: events
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  type                :string(255)
#  description         :text
#  eventable_type      :string(255)
#  eventable_id        :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  user_id             :integer
#  reference_id        :integer
#  creator_id          :integer
#  updater_id          :integer
#  triggering_event_id :integer
#  properties          :hstore
#

# == Creating a New Service Call Event
# 1. Define the event in one of the state machines in ServiceCall, MyServiceCall or TransferredServiceCall
# 2. Add the appropriate before and after callbacks in the applicable observer: ServiceCallObserver, MyServiceCallObserver, TransferredServiceCallObserver
# 3. Ensure the event is properly permissioned in PermittedParams
# 4. If invoking the event requires additional information (i.e. technician for a dispatch) create the appropriate form method in ServiceCallHelper
# 5. use the service_call_event generator to create the service call event class as well as the corresponding notification
# 6. define an event id in the Events spreadsheet to get a number for the event and update the ref attribute in the init method
# 7. update the locale yml files with the notification and event name, description, subject etc.
# 8. instantiate the event in the observer call backs created in step 2.
# 9. update the service_call_pages_spec.rb with tests for the new functionality
# 10. implement the event behavior to get the tests to pass
#
class ServiceCallEvent < Event

  before_create :set_default_creator

  def process_event

    Rails.logger.debug { "Running #{self.class.name} process_event method" }

    update_provider if notify_provider?
    update_subcontractor if notify_subcontractor?

    notify notification_recipients, notification_class unless notification_recipients.nil?

  end

  def service_call
    @service_call ||= self.eventable
  end

  def notify_provider?
    begin

      service_call.provider.subcontrax_member? &&
          service_call.provider_id != service_call.organization_id &&
          !prov_service_call.events.include?(self.triggering_event)
    rescue
      Rails.logger.error { "Error in  ServiceCallEvent#notify_provider" }
    end

  end

  def prov_service_call
    @prov_service_call ||= Ticket.find_by_ref_id_and_organization_id(service_call.ref_id, service_call.provider_id)
  end

  def subcon_service_call
    @subcon_service_call ||= Ticket.find_by_ref_id_and_organization_id(service_call.ref_id, service_call.subcontractor_id)
  end

  def copy_boms_to_provider
    service_call.boms.each do |bom|
      Bom.without_stamps do
        new_bom           = bom.dup
        new_bom.ticket_id = nil
        new_bom.creator   = nil
        new_bom.updater   = nil
        # if the material buyer is the subcontractor or the technician make the buyer the owner of this service call
        if new_bom.buyer.instance_of?(User) || new_bom.buyer == service_call.subcontractor.becomes(Organization)
          new_bom.buyer = service_call.organization
        end
        # todo make atomic operation to allow a proper rollback
        prov_service_call.boms << new_bom
      end
    end
  end

  def notify_subcontractor?
    begin
      service_call.subcontractor.present? &&
          service_call.subcontractor.subcontrax_member? &&
          service_call.subcontractor.id != service_call.organization.id &&
          !subcon_service_call.events.include?(self.triggering_event)
    rescue Exception => err
      Rails.logger.error { "Error in  #{self.class.name}#notify_subcontractor?: \n#{err.inspect}" }
    end

  end

  def update_subcontractor
    nil # should be implemented in the subclass in case the subcontractor needs to be notified
  end

  def update_provider
    nil # should be implemented in the subclass in case the provider needs to be notified
  end

  def set_customer_account_as_paid
    account = Account.for_customer(service_call.customer).lock(true).first
    ticket  = MyServiceCall.find(service_call.ref_id)

    props = { amount:      -(service_call.total_price + (service_call.total_price * (service_call.tax / 100.0))),
              ticket:      ticket,
              event:       self,
              agreement:   service_call.customer.agreements.first,
              description: I18n.t("payment.#{service_call.payment_type}.description", ticket: ticket.id).html_safe }


    case service_call.payment_type
      when 'cash'
        entry = CashPayment.new(props)
        account.entries << entry
        entry.clear
      when 'credit_card'
        entry = CreditPayment.new(props)
        account.entries << entry
      when 'amex_credit_card'
        entry = AmexPayment.new(props)
        account.entries << entry
      when 'cheque'
        account.entries << ChequePayment.new(props)
      else
        raise "#{self.class.name}: Unexpected payment type (#{service_call.payment_type}) when processing the event"
    end
  end

  protected
  def invoke_affiliate_billing
    if service_call.affiliate.present?
      aff_billing = AffiliateBillingService.new(self)
      aff_billing.execute

      aff_billing.accounting_entries.each do |entry|
        entry.clear
      end
    end
  end
end
