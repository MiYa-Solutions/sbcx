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

  def notification_recipients
    if notification_class
      User.where(organization_id: entry.ticket.organization_id).where("preferences @> hstore('#{notification_class.name.underscore}', 'true') OR preferences @> hstore('#{notification_class.name.underscore}', '1')").all
    else
      nil
    end
  end

  protected

  def clear_collection_entry
    deposit_event = entry.ticket.events.where("properties @> hstore(?, ?)", 'deposit_entry_id', entry.id.to_s).first
    deposit_event.entry.clear!
  end


end