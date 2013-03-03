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
    @ticket = event.eventable
    @event = event
    case @ticket.my_role
      when :prov
        organization_entries
      when :subcon
        counterparty_entries
      else
        raise "Unrecognized role when creting profit split entries"
    end

  end

  # todo implement timebound check
  def applicable?(event)
    event.instance_of?(ServiceCallCompletedEvent) ||
        (event.instance_of?(ServiceCallCompleteEvent) &&
            event.eventable.instance_of?(MyServiceCall) &&
            event.eventable.transferred?) ||
        (event.instance_of?(ServiceCallCompleteEvent) && event.eventable.instance_of?(TransferredServiceCall))
  end

  private

  def counterparty_cut
    @ticket.total_profit * (rate / 100.0)
  end

  def organization_entries

    entries = []


    entries << PaymentToSubcontractor.new(event: @event, ticket: @ticket, amount: counterparty_cut, description: "Entry to provider owned account")
    entries
  end

  def counterparty_entries
    entries = []
    entries << IncomeFromProvider.new(event: @event, ticket: @ticket, amount: counterparty_cut, description: "Entry to subcontractor owned account")
    entries
  end

end
