class FlatFee < AffiliatePostingRule

  # setup rule specific attributes that are stored in an hstore column and get the standard methods for it
  setup_hstore_attr 'bom_reimbursement'

  def rate_types
    [:na]
  end


  class TransferProperties < TicketProperties
    column :bom_reimbursement, :boolean
    column :subcon_fee_cents, :integer
    column :subcon_fee_currency, :string

    monetize :subcon_fee_cents
  end

  protected

  def counterparty_cut
    @ticket.subcon_fee
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

      when 'amex_credit_card'
        fee_props[:amount] = amex_fee * (rate / 100.0)
        entries << AmexPaymentFee.new(fee_props) unless amex_rate.nil? || amex_rate.delete(',').to_f == 0.0

      when 'cheque'
        fee_props[:amount] = cheque_fee * (rate / 100.0)
        entries << ChequePaymentFee.new(fee_props) unless cheque_rate.nil? || cheque_rate.delete(',').to_f == 0.0
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
        entries << ReimbursementForCashPayment.new(fee_props) unless cash_rate.nil? || cash_rate.delete(',').to_f == 0.0
      when 'credit_card'
        fee_props[:amount] = credit_fee * (rate / 100.0)
        entries << ReimbursementForCreditPayment.new(fee_props) unless credit_rate.nil? || credit_rate.delete(',').to_f == 0.0
      when 'amex_credit_card'
        fee_props[:amount] = amex_fee * (rate / 100.0)
        entries << ReimbursementForAmexPayment.new(fee_props) unless amex_rate.nil? || amex_rate.delete(',').to_f == 0.0
      when 'cheque'
        fee_props[:amount] = cheque_fee * (rate / 100.0)
        entries << ReimbursementForChequePayment.new(fee_props) unless cheque_rate.nil? || cheque_rate.delete(',').to_f == 0.0
      else
    end
    entries
  end

  def cparty_collection_entries
    entries = []

    collection_props = {
        status:      AccountingEntry::STATUS_CLEARED,
        amount:      @ticket.total_price + (@ticket.total_price * (@ticket.tax / 100.0)),
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

      when 'amex_credit_card'
        fee_props[:amount] = amex_fee * (rate / 100.0)
        entries << AmexCollectionForProvider.new(collection_props)
        entries << AmexPaymentFee.new(fee_props) unless amex_rate.nil? || amex_rate.delete(',').to_f == 0

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
                         amount:      @ticket.total_price + (@ticket.total_price * (@ticket.tax / 100.0)),
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
        entries << ReimbursementForCashPayment.new(fee_props) unless cash_rate.nil? || cash_rate.delete(',').to_f == 0
      when 'credit_card'
        fee_props[:amount] = credit_fee * (rate / 100.0)
        entries << CreditCardCollectionFromSubcon.new(collection_props)
        entries << ReimbursementForCreditPayment.new(fee_props) unless credit_rate.nil? || credit_rate.delete(',').to_f == 0
      when 'amex_credit_card'
        fee_props[:amount] = amex_fee * (rate / 100.0)
        entries << AmexCollectionFromSubcon.new(collection_props)
        entries << ReimbursementForAmexPayment.new(fee_props) unless amex_rate.nil? || amex_rate.delete(',').to_f == 0
      when 'cheque'
        fee_props[:amount] = cheque_fee * (rate / 100.0)
        entries << ChequeCollectionFromSubcon.new(collection_props)
        entries << ReimbursementForChequePayment.new(fee_props) unless cheque_rate.nil? || cheque_rate.delete(',').to_f == 0

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

  def org_settlement_entries
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
      when 'amex_credit_card'
        payment_reimbursement = AccountingEntry.where(type: ReimbursementForAmexPayment, ticket_id: @ticket.id).first
      when 'cheque'
        payment_reimbursement = AccountingEntry.where(type: ReimbursementForChequePayment, ticket_id: @ticket.id).first
      else
        Rails.logger.debug { "ProfitSplit#organization_settlement_entries - payment fees are not taken in account when calculating settlement amount" } #raise "ProfitSplit#organization_settlement_entries - unexpected payment type: #{@ticket.payment_type}. expected 'case', 'credit_cart' or 'cheque'"

    end

    total += payment_reimbursement.amount if payment_reimbursement.present?

    case @ticket.subcon_payment
      when 'cash'
        result << CashPaymentToAffiliate.new(event: @event, ticket: @ticket, amount: total.abs, description: "Entry to provider owned account")
      when 'credit_card'
        result << CreditPaymentToAffiliate.new(event: @event, ticket: @ticket, amount: total.abs, description: "Entry to provider owned account")
      when 'amex_credit_card'
        result << AmexPaymentToAffiliate.new(event: @event, ticket: @ticket, amount: total.abs, description: "Entry to provider owned account")
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
      if bom.mine?
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
        payment_fee = AccountingEntry.where(type: CreditPaymentFee, ticket_id: @ticket.id).first
      when 'amex_credit_card'
        payment_fee = AccountingEntry.where(type: AmexPaymentFee, ticket_id: @ticket.id).first
      when 'cheque'
        payment_fee = AccountingEntry.where(type: ChequePaymentFee, ticket_id: @ticket.id).first
      else
        Rails.logger.debug { "ProfitSplit#counterparty_settlement_entries - payment fees are not taken into account when calculating settlement amount" } #raise "ProfitSplit#organization_settlement_entries - unexpected payment type: #{@ticket.payment_type}. expected 'cash', 'credit_cart' or 'cheque'"

    end

    total += payment_fee.amount if payment_fee.present?


    case @ticket.provider_payment
      when 'cash'
        result << CashPaymentFromAffiliate.new(event: @event, ticket: @ticket, amount: total.abs, description: "Entry to provider owned account")
      when 'credit_card'
        result << CreditPaymentFromAffiliate.new(event: @event, ticket: @ticket, amount: total.abs, description: "Entry to provider owned account")
      when 'amex_credit_card'
        result << AmexPaymentFromAffiliate.new(event: @event, ticket: @ticket, amount: total.abs, description: "Entry to provider owned account")
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
        raise "Unrecognized role when creating profit split entries"
    end

  end

  def counterparty_cancellation_entries
    original_entry = AccountingEntry.where(type: IncomeFromProvider, ticket_id: @ticket.id).first

    case @ticket.payment_type
      when 'cash'
        payment_fee_entry = AccountingEntry.where(type: CashPaymentFee, ticket_id: @ticket.id).first
        collection_entry  = AccountingEntry.where(type: CashCollectionForProvider, ticket_id: @ticket.id).first
        deposit_entry     = AccountingEntry.where(type: CashDepositToProvider, ticket_id: @ticket.id).first
      when 'credit_card'
        payment_fee_entry = AccountingEntry.where(type: CreditPaymentFee, ticket_id: @ticket.id).first
        collection_entry  = AccountingEntry.where(type: CreditCardCollectionForProvider, ticket_id: @ticket.id).first
        deposit_entry     = AccountingEntry.where(type: CreditCardDepositToProvider, ticket_id: @ticket.id).first
      when 'amex_credit_card'
        payment_fee_entry = AccountingEntry.where(type: AmexPaymentFee, ticket_id: @ticket.id).first
        collection_entry  = AccountingEntry.where(type: AmexCollectionForProvider, ticket_id: @ticket.id).first
        deposit_entry     = AccountingEntry.where(type: AmexDepositToProvider, ticket_id: @ticket.id).first
      when 'cheque'
        payment_fee_entry = AccountingEntry.where(type: ChequePaymentFee, ticket_id: @ticket.id).first
        collection_entry  = AccountingEntry.where(type: ChequeCollectionForProvider, ticket_id: @ticket.id).first
        deposit_entry     = AccountingEntry.where(type: ChequeDepositToProvider, ticket_id: @ticket.id).first
      when nil
        # leave adjustment as zero
      else
        raise "unexpected payment type: '#{@ticket.payment_type}'"
    end

    payment_fee    = payment_fee_entry ? payment_fee_entry.amount : Money.new_with_amount(0)
    collection_fee = collection_entry ? collection_entry.amount : Money.new_with_amount(0)
    deposit_fee    = deposit_entry ? deposit_entry.amount : Money.new_with_amount(0)
    adjustment     = payment_fee + collection_fee + deposit_fee

    [CanceledJobAdjustment.new(event: @event, ticket: @ticket, amount: -(original_entry.amount + adjustment), description: "Entry to provider owned account")]
  end

  def organization_cancellation_entries
    original_entry = AccountingEntry.where(type: PaymentToSubcontractor, ticket_id: @ticket.id).first
    case @ticket.payment_type
      when 'cash'
        payment_fee_entry = AccountingEntry.where(type: ReimbursementForCashPayment, ticket_id: @ticket.id).first
        collection_entry  = AccountingEntry.where(type: CashCollectionFromSubcon, ticket_id: @ticket.id).first
        deposit_entry     = AccountingEntry.where(type: CashDepositFromSubcon, ticket_id: @ticket.id).first
      when 'credit_card'
        payment_fee_entry = AccountingEntry.where(type: ReimbursementForCreditPayment, ticket_id: @ticket.id).first
        collection_entry  = AccountingEntry.where(type: CreditCardCollectionFromSubcon, ticket_id: @ticket.id).first
        deposit_entry     = AccountingEntry.where(type: CreditCardDepositFromSubcon, ticket_id: @ticket.id).first
      when 'credit_card'
        payment_fee_entry = AccountingEntry.where(type: ReimbursementForAmexPayment, ticket_id: @ticket.id).first
        collection_entry  = AccountingEntry.where(type: AmexCollectionFromSubcon, ticket_id: @ticket.id).first
        deposit_entry     = AccountingEntry.where(type: AmexDepositFromSubcon, ticket_id: @ticket.id).first
      when 'cheque'
        payment_fee_entry = AccountingEntry.where(type: ReimbursementForChequePayment, ticket_id: @ticket.id).first
        collection_entry  = AccountingEntry.where(type: ChequeCollectionFromSubcon, ticket_id: @ticket.id).first
        deposit_entry     = AccountingEntry.where(type: ChequeDepositFromSubcon, ticket_id: @ticket.id).first
      when nil
        # leave adjustment as zero
      else
        raise "unexpected payment type"
    end

    payment_fee    = payment_fee_entry ? payment_fee_entry.amount : Money.new_with_amount(0)
    collection_fee = collection_entry ? collection_entry.amount : Money.new_with_amount(0)
    deposit_fee    = deposit_entry ? deposit_entry.amount : Money.new_with_amount(0)
    adjustment     = payment_fee + collection_fee + deposit_fee

    [CanceledJobAdjustment.new(event: @event, ticket: @ticket, amount: -(original_entry.amount + adjustment), description: "Entry to provider owned account")]
  end


end