require 'hstore_setup_methods'
class ScConfirmDepositEvent < ServiceCallEvent
  extend HstoreSetupMethods

  setup_hstore_attr 'entry_id'
  setup_hstore_attr 'matching_entry_id'

  def init
    self.name         = I18n.t('service_call_confirm_deposit_event.name')
    self.description  = I18n.t('service_call_confirm_deposit_event.description', subcontractor: service_call.subcontractor.name)
    self.reference_id = 100025
  end

  def notification_recipients
    nil
  end

  def notification_class
    nil
  end

  def update_subcontractor
    subcon_service_call.events << ScDepositConfirmedEvent.new(triggering_event: self)
  end

  private

  def entry
    @entry ||= AccountingEntry.find entry_id
  end


end
