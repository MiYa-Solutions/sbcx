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
      when ScCollectEvent.name, ScCollectedEvent.name
        collection_entries
      when ServiceCallPaidEvent.name
        payment_entries

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
      when ScCollectEvent.name
        true
      when ServiceCallPaidEvent.name
        true
      when ScCollectedEvent.name
        true
      else
        false
    end
  end

  def cash_fee
    case cash_rate_type
      when 'percentage'
        @ticket.total_price * (cash_rate.delete(',').to_f / 100.0)
      when 'flat_fee'
        Money.new_with_amount(cash_rate.delete(',').to_f)
      else
        raise "Unexpected cash rate type for profit split rule. received #{cash_rate_type}, expected either percentage or flat_fee"
    end
  end

  def credit_fee
    case credit_rate_type
      when 'percentage'
        @ticket.total_price * (credit_rate.delete(',').to_f / 100.0)
      when 'flat_fee'
        Money.new_with_amount(credit_rate.delete(',').to_f)
      else
        raise "Unexpected cash rate type for profit split rule. received #{cash_rate_type}, expected either percentage or flat_fee"
    end
  end

  def cheque_fee
    case cheque_rate_type
      when 'percentage'
        @ticket.total_price * (cheque_rate.delete(',').to_f / 100.0)
      when 'flat_fee'
        Money.new_with_amount(cheque_rate.delete(',').to_f)
      else
        raise "Unexpected cash rate type for profit split rule. received #{cash_rate_type}, expected either percentage or flat_fee"
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
        raise "Unrecognized role when creating profit split entries"
    end
  end

  def collection_entries
    case @ticket.my_role
      when :prov
        org_collection_entries
      when :subcon
        cparty_collection_entries
      else
        raise "Unrecognized role when creating profit split entries"

    end
  end

  def payment_entries
    case @ticket.my_role
      when :prov
        org_payment_entries
      when :subcon
        cparty_payment_entries
      else
        raise "Unrecognized role when creating profit split entries"

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

  def cparty_payment_entries
    entries = []

    fee_props = {
        status:      AccountingEntry::STATUS_CLEARED,
        ticket:      @ticket,
        event:       @event,
        description: I18n.t("payment_fee.#{@ticket.payment_type}.description", ticket: @ticket.id).html_safe
    }

    case @ticket.payment_type
      when 'cash'
        fee_props[:amount] = cash_fee * (rate / 100.0)
        entries << CashPaymentFee.new(fee_props) unless cash_rate.nil? || cash_rate.delete(',').to_f == 0.0

      when 'credit_card'
        fee_props[:amount] = credit_fee * (rate / 100.0)
        entries << CreditPaymentFee.new(fee_props) unless credit_rate.nil? || credit_rate.delete(',').to_f == 0.0

      when 'cheque'
        fee_props[:amount] = cheque_fee * (rate / 100.0)
        entries << ChequePaymentFee.new(fee_props) unless cheque_rate.nil? || cheque_rate.delete(',').to_f == 0
      else
        raise "#{self.class.name}: Unexpected payment type (#{@ticket.payment_type}) when processing the event"
    end

    entries
  end

  def org_payment_entries
    entries   = []
    fee_props = {
        status:      AccountingEntry::STATUS_CLEARED,
        ticket:      @ticket,
        event:       @event,
        description: I18n.t("payment_reimbursement.#{@ticket.payment_type}.description", ticket: @ticket.id).html_safe
    }


    case @ticket.payment_type
      when 'cash'
        fee_props[:amount] = cash_fee * (rate / 100.0)
        entries << ReimbursementForCashPayment.new(fee_props) unless cash_rate.nil? || cash_rate == 0
      when 'credit_card'
        fee_props[:amount] = @ticket.total_price * (credit_rate.delete(',').to_f / 100.0) * (rate / 100.0)
        entries << ReimbursementForCreditPayment.new(fee_props) unless credit_rate.nil? || credit_rate == 0
      when 'cheque'
        fee_props[:amount] = @ticket.total_price * (cheque_rate.delete(',').to_f / 100.0) * (rate / 100.0)
        entries << ReimbursementForChequePayment.new(fee_props) unless cheque_rate.nil? || cheque_rate == 0
      else
    end
    entries
  end

  def cparty_collection_entries
    entries = []

    collection_props = {
        status:      AccountingEntry::STATUS_CLEARED,
        amount:      @ticket.total_price,
        ticket:      @ticket,
        event:       @event,
        description: I18n.t("payment.#{@ticket.payment_type}.description", ticket: @ticket.id).html_safe
    }

    fee_props = { status:      AccountingEntry::STATUS_CLEARED,
                  ticket:      @ticket,
                  event:       @event,
                  description: I18n.t("payment_fee.#{@ticket.payment_type}.description", ticket: @ticket.id).html_safe
    }

    case @ticket.payment_type
      when 'cash'
        entries << CashCollectionForProvider.new(collection_props)
        fee_props[:amount] = cash_fee * (rate / 100.0)
        entries << CashPaymentFee.new(fee_props) unless cash_rate.nil? || cash_rate.delete(',').to_f == 0

      when 'credit_card'
        fee_props[:amount] = credit_fee * (rate / 100.0)
        entries << CreditCardCollectionForProvider.new(collection_props)
        entries << CreditPaymentFee.new(fee_props) unless credit_rate.nil? || credit_rate.delete(',').to_f == 0

      when 'cheque'
        fee_props[:amount] = cheque_fee * (rate / 100.0)
        entries << ChequeCollectionForProvider.new(collection_props)
        entries << ChequePaymentFee.new(fee_props) unless cheque_rate.nil? || cheque_rate.delete(',').to_f == 0


      else
        raise "#{self.class.name}: Unexpected payment type (#{@ticket.payment_type}) when processing the event"

    end

    entries
  end

  def org_collection_entries
    entries          = []
    collection_props = { status:      AccountingEntry::STATUS_CLEARED,
                         amount:      @ticket.total_price,
                         ticket:      @ticket,
                         event:       @event,
                         description: I18n.t("payment.#{@ticket.payment_type}.description", ticket: @ticket.id).html_safe }

    fee_props = { status:      AccountingEntry::STATUS_CLEARED,
                  ticket:      @ticket,
                  event:       @event,
                  description: I18n.t("payment_reimbursement.#{@ticket.payment_type}.description", ticket: @ticket.id).html_safe }


    case @ticket.payment_type
      when 'cash'
        entries << CashCollectionFromSubcon.new(collection_props)

        fee_props[:amount] = cash_fee * (rate / 100.0)
        entries << ReimbursementForCashPayment.new(fee_props) unless cash_rate.nil? || cash_rate == 0
      when 'credit_card'
        fee_props[:amount] = @ticket.total_price * (credit_rate.delete(',').to_f / 100.0) * (rate / 100.0)
        entries << CreditCardCollectionFromSubcon.new(collection_props)
        entries << ReimbursementForCreditPayment.new(fee_props) unless credit_rate.nil? || credit_rate == 0
      when 'cheque'
        fee_props[:amount] = @ticket.total_price * (cheque_rate.delete(',').to_f / 100.0) * (rate / 100.0)
        entries << ChequeCollectionFromSubcon.new(collection_props)
        entries << ReimbursementForChequePayment.new(fee_props) unless cheque_rate.nil? || cheque_rate == 0

      else

    end


    entries
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

    case @ticket.payment_type
      when 'cash'
        payment_reimbursement = AccountingEntry.where(type: ReimbursementForCashPayment, ticket_id: @ticket.id).first
      when 'credit_card'
        payment_reimbursement = AccountingEntry.where(type: ReimbursementForCreditPayment, ticket_id: @ticket.id).first
      when 'cheque'
        payment_reimbursement = AccountingEntry.where(type: ReimbursementForChequePayment, ticket_id: @ticket.id).first
      else
        raise "ProfitSplit#organization_settlement_entries - unexpected payment type: #{@ticket.payment_type}. expected 'case', 'credit_cart' or 'cheque'"

    end

    total += payment_reimbursement.amount if payment_reimbursement.present?

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

    case @ticket.payment_type
      when 'cash'
        payment_fee = AccountingEntry.where(type: CashPaymentFee, ticket_id: @ticket.id).first
      when 'credit_card'
        payment_fee = AccountingEntry.where(type:CreditPaymentFee, ticket_id: @ticket.id).first
      when 'cheque'
        payment_fee = AccountingEntry.where(type:ChequePaymentFee, ticket_id: @ticket.id).first
      else
        raise "ProfitSplit#organization_settlement_entries - unexpected payment type: #{@ticket.payment_type}. expected 'cash', 'credit_cart' or 'cheque'"

    end

    total += payment_fee.amount if payment_fee.present?


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
    [CanceledJobAdjustment.new(event: @event, ticket: @ticket, amount: -original_entry.amount, description: "Entry to provider owned account")]
  end

  def organization_cancellation_entries
    original_entry = AccountingEntry.where(type: PaymentToSubcontractor, ticket_id: @ticket.id).first
    [CanceledJobAdjustment.new(event: @event, ticket: @ticket, amount: -original_entry.amount, description: "Entry to provider owned account")]
  end


end
