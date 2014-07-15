class CollectionEntryFactory

  def initialize(options = {})
    @event        = options[:event]
    @ticket       = options[:ticket]
    @agreement    = options[:agreement]
    @posting_rule = options[:posting_rule]
    @account      = options[:account]
  end

  def generate
    entries = []

    entry1 = collection_entry
    entry2 = fee_payment_entry

    entries << entry1 if entry1
    entries << entry2 if entry2

    entries
  end

  protected

  def matching_entry(klass)
    if @event.triggering_event
      @event.triggering_event.accounting_entries.where(type: klass).first
    end
  end

  def valid_rate?(rate)
    !(rate.nil? || rate.delete(',').to_f == 0)
  end

  def collected_by_me?
    @event.collector.instance_of?(User) && @event.collector.organization == @account.organization ||
        @event.collector.becomes(Organization) == @account.organization
  end

end
