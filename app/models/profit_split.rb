# == Schema Information
#
# Table name: posting_rules
#
#  id             :integer         not null, primary key
#  agreement_id   :integer
#  type           :string(255)
#  rate           :decimal(, )
#  rate_type      :string(255)
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  properties     :hstore
#  time_bound     :boolean         default(FALSE)
#  sunday         :boolean         default(FALSE)
#  monday         :boolean         default(FALSE)
#  tuesday        :boolean         default(FALSE)
#  wednesday      :boolean         default(FALSE)
#  thursday       :boolean         default(FALSE)
#  friday         :boolean         default(FALSE)
#  saturday       :boolean         default(FALSE)
#  sunday_from    :time
#  monday_from    :time
#  tuesday_from   :time
#  wednesday_from :time
#  thursday_from  :time
#  friday_from    :time
#  saturday_from  :time
#  sunday_to      :time
#  monday_to      :time
#  tuesday_to     :time
#  wednesday_to   :time
#  thursday_to    :time
#  friday_to      :time
#  saturday_to    :time
#

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
      entries << SubcontractingJob.new(event: event, ticket: event.eventable, account: account, amount: (event.eventable.total_profit * ((100.0 - rate) / 100.0)), description: "Entry to provider owned account")
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
      entries << SubcontractingJob.new(event: event, ticket: event.eventable, account: account, amount: (event.eventable.total_profit * (rate / 100.0)), description: "Entry to subcontractor owned account")
    end
    entries
  end

end
