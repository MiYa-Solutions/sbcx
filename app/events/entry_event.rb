require 'hstore_setup_methods'
class EntryEvent < Event
  extend HstoreSetupMethods
  setup_hstore_attr 'entry_id'

  def process_event
    notify notification_recipients, notification_class unless notification_recipients.nil?
  end

  def entry
    @entry ||= AccountingEntry.find entry_id
  end
end