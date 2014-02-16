require 'hstore_setup_methods'
class EntryEvent < Event
  extend HstoreSetupMethods
  setup_hstore_attr 'entry_id'

  def entry
    AccountingEntry.find entry_id
  end
end