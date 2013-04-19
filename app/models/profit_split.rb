# == Schema Information
#
# Table name: posting_rules
#
#  id             :integer          not null, primary key
#  agreement_id   :integer
#  type           :string(255)
#  rate           :decimal(, )
#  rate_type      :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  properties     :hstore
#  time_bound     :boolean          default(FALSE)
#  sunday         :boolean          default(FALSE)
#  monday         :boolean          default(FALSE)
#  tuesday        :boolean          default(FALSE)
#  wednesday      :boolean          default(FALSE)
#  thursday       :boolean          default(FALSE)
#  friday         :boolean          default(FALSE)
#  saturday       :boolean          default(FALSE)
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
  %w[cheque_rate cheque_rate_type credit_rate credit_rate_type
cash_rate cash_rate_type].each do |key|
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
    @event  = event

    case event.class.name
      when ServiceCallCompletedEvent.name, ServiceCallCompleteEvent.name
        charge_entries
      when ScSubconSettleEvent.name, ScSubconSettledEvent.name, ScProviderSettleEvent.name, ScProviderSettledEvent.name
        settlement_entries
      when ServiceCallCancelEvent.name, ServiceCallCanceledEvent.name
        cancellation_entries
      else
        raise "Unexpected Event to be processed by ProfitSplit posting rule"
    end
  end

  # todo implement timebound check
  def applicable?(event)
    case event.class.name
      when ServiceCallCompletedEvent.name
        true
      when ServiceCallCompleteEvent.name
        event.eventable.instance_of?(MyServiceCall) && event.eventable.transferred? ||
            event.eventable.instance_of?(TransferredServiceCall)
      when ScSubconSettleEvent.name
        true
      when ScProviderSettleEvent.name
        true
      when ScSubconSettledEvent.name
        true
      when ScProviderSettledEvent.name
        true
      when ServiceCallCancelEvent.name
        true
      when ServiceCallCanceledEvent.name
        true
      else
    end
  end

  private

  def counterparty_cut
    @ticket.total_profit * (rate / 100.0)
  end

  def charge_entries
    case @ticket.my_role
      when :prov
        organization_entries
      when :subcon
        counterparty_entries
      else
        raise "Unrecognized role when creting profit split entries"
    end
  end

  def settlement_entries
    case @ticket.my_role
      when :prov
        organization_settlement_entries
      when :subcon
        counterparty_settlement_entries
      else
        raise "Unrecognized role when creting profit split entries"
    end
  end

  def organization_entries
    entries = []
    entries << PaymentToSubcontractor.new(event: @event, ticket: @ticket, amount: counterparty_cut, description: "Entry to provider owned account")
    @ticket.boms.each do |bom|
      if bom.buyer == agreement.counterparty
        entries << MaterialReimbursementToCparty.new(event: @event, ticket: @ticket, amount: bom.total_cost, description: "Material Reimbursement to subcon")
      end
    end
    entries
  end

  def organization_settlement_entries
    result = []
    total  = Money.new_with_amount(0)

    charge = AccountingEntry.where(type: PaymentToSubcontractor, ticket_id: @ticket.id).first
    total += charge.amount if charge.present?

    entries = AccountingEntry.where(type: MaterialReimbursementToCparty, ticket_id: @ticket.id)
    entries.each do |entry|
      total += entry.amount
    end

    case @ticket.subcon_payment
      when 'cash'
        result << CashPaymentToAffiliate.new(event: @event, ticket: @ticket, amount: total.abs, description: "Entry to provider owned account")
      when 'credit_card'
        result << CreditPaymentToAffiliate.new(event: @event, ticket: @ticket, amount: total.abs, description: "Entry to provider owned account")
      when 'cheque'
        result << ChequePaymentToAffiliate.new(event: @event, ticket: @ticket, amount: total.abs, description: "Entry to provider owned account")
      else

    end

    result
  end

  def counterparty_entries
    entries = []
    entries << IncomeFromProvider.new(event: @event, ticket: @ticket, amount: counterparty_cut, description: "Entry to subcontractor owned account")
    @ticket.boms.each do |bom|
      if bom.buyer == agreement.counterparty
        entries << MaterialReimbursement.new(event: @event, ticket: @ticket, amount: bom.total_cost, description: "Material Reimbursement to subcon")
      end
    end

    entries
  end

  def counterparty_settlement_entries
    result = []
    total  = Money.new_with_amount(0)

    charge = AccountingEntry.where(type: IncomeFromProvider, ticket_id: @ticket.id).first
    total += charge.amount if charge.present?

    entries = AccountingEntry.where(type: MaterialReimbursement, ticket_id: @ticket.id)
    entries.each do |entry|
      total += entry.amount
    end

    case @ticket.provider_payment
      when 'cash'
        result << CashPaymentFromAffiliate.new(event: @event, ticket: @ticket, amount: total.abs, description: "Entry to provider owned account")
      when 'credit_card'
        result << CreditPaymentFromAffiliate.new(event: @event, ticket: @ticket, amount: total.abs, description: "Entry to provider owned account")
      when 'cheque'
        result << ChequePaymentFromAffiliate.new(event: @event, ticket: @ticket, amount: total.abs, description: "Entry to provider owned account")
      else

    end

    result

  end

  def cancellation_entries
    case @ticket.my_role
      when :prov
        organization_cancellation_entries
      when :subcon
        counterparty_cancellation_entries
      else
        raise "Unrecognized role when creting profit split entries"
    end

  end

  def counterparty_cancellation_entries
    original_entry = AccountingEntry.where(type: IncomeFromProvider, ticket_id: @ticket.id).first
    [CanceledJobAdjustment.new(event: @event, ticket: @ticket, amount: - original_entry.amount, description: "Entry to provider owned account")]
  end

  def organization_cancellation_entries
    original_entry = AccountingEntry.where(type: PaymentToSubcontractor, ticket_id: @ticket.id).first
    [CanceledJobAdjustment.new(event: @event, ticket: @ticket, amount: - original_entry.amount, description: "Entry to provider owned account")]
  end

end
