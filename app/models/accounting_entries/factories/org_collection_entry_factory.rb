class OrgCollectionEntryFactory < CollectionEntryFactory

  protected

  def collection_entry
    unless collected_by_me?
      case @event.payment_type
        when 'cash'
          CashCollectionFromSubcon.new(collection_props.update(matching_entry: matching_entry(CashCollectionForProvider)))
        when 'credit_card'
          CreditCardCollectionFromSubcon.new(collection_props.update(matching_entry: matching_entry(CreditCardCollectionForProvider)))
        when 'amex_credit_card'
          AmexCollectionFromSubcon.new(collection_props.update(matching_entry: matching_entry(AmexCollectionForProvider)))
        when 'cheque'
          ChequeCollectionFromSubcon.new(collection_props.update(matching_entry: matching_entry(ChequeCollectionForProvider)))
        else
          raise "Unexpected payment type: #{@event.payment_type}"
      end
    end
  end

  def fee_payment_entry
    entry = nil
    case @event.payment_type
      when 'cash'
        if valid_rate?(@posting_rule.cash_rate)
          entry = ReimbursementForCashPayment.new(fee_props.update(amount: @posting_rule.cash_fee,
                                                                   matching_entry: matching_entry(CashPaymentFee)))
        end
      when 'credit_card'
        if valid_rate?(@posting_rule.credit_rate)
          entry = ReimbursementForCreditPayment.new(fee_props.update(amount: @posting_rule.credit_fee,
                                                                     matching_entry: matching_entry(CreditPaymentFee)))
        end
      when 'amex_credit_card'
        if valid_rate?(@posting_rule.amex_rate)
          entry = ReimbursementForAmexPayment.new(fee_props.update(amount: @posting_rule.amex_fee,
                                                                   matching_entry: matching_entry(AmexPaymentFee)))
        end
      when 'cheque'
        if valid_rate?(@posting_rule.cheque_rate)
          entry = ReimbursementForChequePayment.new(fee_props.update(amount: @posting_rule.cheque_fee,
                                                                     matching_entry: matching_entry(ChequePaymentFee)))
        end

      else
        raise "Unexpected payment type: #{@event.payment_type}"

    end

    entry

  end

  private

  def fee_props
    {
        status:      AccountingEntry::STATUS_CLEARED,
        ticket:      @ticket,
        event:       @event,
        agreement:   @agreement,
        description: I18n.t("payment_reimbursement.#{@ticket.payment_type}.description", ticket: @ticket.id).html_safe
    }
  end

  def collection_props
    {
        amount:      @event.amount,
        collector:   @event.collector,
        ticket:      @ticket,
        event:       @event,
        agreement:   @agreement,
        description: I18n.t("payment.#{@ticket.payment_type}.description", ticket: @ticket.id).html_safe
    }

  end


end