require 'hstore_setup_methods'
class AccountAdjustedEvent < Event
  extend HstoreSetupMethods

  setup_hstore_attr 'orig_entry_id'
  setup_hstore_attr 'entry_id'

  alias_method :account, :eventable

  def init
    self.name         = I18n.t('account_adjusted_event.name')
    self.description  = I18n.t('account_adjusted_event.description')
    self.reference_id = 300001
  end

  def process_event
    entry = ReceivedAdjEntry.new(amount: orig_entry.amount)
    account.entries << entry
    self.entry_id      = entry.id
    self.orig_entry_id = orig_entry.id
    self.save!
  end

  private

  def orig_entry
    AccountingEntry.find(self.triggering_event.entry_id)
  end

  def new_adj_entry
    @new_adj_entry ||= ReceivedAdjEntry.new(amount: orig_entry.amount)
  end

end
