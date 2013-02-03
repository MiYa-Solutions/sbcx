class ProfitSplit < PostingRule

  # define hstore properties methods
  %w[sunday monday].each do |key|
    scope "has_#{key}", lambda { |org_id, value| colleagues(org_id).where("properties @> (? => ?)", key, value) }

    define_method(key) do
      properties && properties[key]
    end

    define_method("#{key}=") do |value|
      self.properties = (properties || {}).merge(key => value)
    end
  end

  def rate_types
    [:percentage]
  end

  def get_entries(event)
    entries = []

    entries = entries + organization_entries(event)
    entries + counterparty_entries(event)

  end

  # todo implement timebound check
  def applicable?(event)
    if event.instance_of?(ServiceCallCompletedEvent) || event.instance_of?(ServiceCallCompleteEvent)
      true
    else
      false
    end
  end

  private
  def organization_entries(event)
    entries = []

    account = Account.where("organization_id = ? AND accountable_id = ? AND accountable_type = ?",
                            agreement.organization_id,
                            agreement.counterparty_id,
                            agreement.counterparty_type).first
    unless account.nil?
      entries << SubcontractingJob.new(event: event, ticket: event.eventable, account: account, amount: (event.eventable.total_profit / 2.0), description: "Entry to provider owned account")
    end
    entries
  end

  def counterparty_entries(event)
    entries = []
    account = Account.where("organization_id = ? AND accountable_id = ? AND accountable_type = ?",
                            agreement.counterparty_id,
                            agreement.organization_id,
                            agreement.counterparty_type).first
    unless account.nil?
      entries << SubcontractingJob.new(event: event, ticket: event.eventable, account: account, amount: (event.eventable.total_profit / 2.0), description: "Entry to subcontractor owned account")
    end
    entries
  end

end