require 'hstore_setup_methods'
class AdjustmentEvent < Event
  extend HstoreSetupMethods

  setup_hstore_attr 'entry_id'


  def process_event
    raise "process event was invoked on AccountingEvent - did you forget to implement it in the subclass?"
  end

  protected

  def account
    eventable
  end

  def affiliate
    account.accountable
  end

  def entry
    AccountingEntry.find(entry_id)
  end

end
