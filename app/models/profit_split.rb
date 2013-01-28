class ProfitSplit < PostingRule

  # define hstore properties methods
  %w[sunday monday].each do |key|
    scope "has_#{key}", lambda { |org_id, value| colleagues(org_id).where("properties @> (? => ?)", key, value) }

    define_method(key) do
      properties && properties[key]
    end

    define_method("#{key}=") do |value|
      self.properties = (properties || { }).merge(key => value)
    end
  end

  def rate_types
    %w[percentage]
  end

  def process(event)
    entries = []

    entries = entries + provider_entries(event)
    entries = entries + subcontractor_entries(event)
    entries = entries + technician_entries(event)
  end

  private
  def provider_entries(event)
    entries = []
    if event.provider.subcontrax_member?
      account = Account.where("organization_id = ? AND accountable_id = ? AND accountable_type = 'Organization'", event.provider.id, event.subcontractor.id).first
      entries << SubcontractingJob.new(event: event, ticket: event.ticket, account: account, amount: (event.total_profit / 2.0), description: "Entry to provider owned account")
    end
    entries
  end

  def subcontractor_entries(event)
    entries = []
    if event.subcontractor.subcontrax_member?
      account = Account.where("organization_id = ? AND accountable_id = ? AND accountable_type = 'Organization'", event.subcontractor.id, event.provider.id).first
      entries << SubcontractingJob.new(event: event, ticket: event.ticket, account: account, amount: (event.total_profit / 2.0), description: "Entry to subcontractor owned account")
    end
    entries
  end

  def technician_entries(event)
    entries = []
    #if event.provider.subcontrax_member?
    #  account = Account.where("organization_id = ? AND accountable_id = ? AND accountable_type = 'Organization'", event.provider.id, event.subcontractor.id).first
    #  entries << SubcontractingJob.new( event: event, ticket: event.ticket, account: account, amount: (event.total_profit / 2.0), description: "TEST")
    #end
    entries
  end

end