require 'hstore_setup_methods'
class AccountAdjustmentEvent < Event
  extend HstoreSetupMethods

  setup_hstore_attr 'entry_id'

  def init
    self.name         = I18n.t('account_adjustment_event.name')
    self.description  = I18n.t('account_adjustment_event.description')
    self.reference_id = 300000
  end

  def process_event
    affiliate_account.events <<
        AccountAdjustedEvent.new(triggering_event: self)
  end

  private

  def affiliate_account
    Account.for_affiliate(eventable.organization, eventable.accountable).first
  end

  def affiliate
    eventable.accountable
  end

end
