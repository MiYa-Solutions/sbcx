class FlatFee < AffiliatePostingRule

  def bom_reimbursement?
    get_transfer_props.bom_reimbursement?
  end

  def rate_types
    [:na]
  end

  def rate
    0.0
  end


  class TransferProperties < TicketProperties
    column :bom_reimbursement, :boolean
    column :subcon_fee_cents, :integer
    column :subcon_fee_currency, :string
    column :provider_fee_cents, :integer
    column :provider_fee_currency, :string
    monetize :subcon_fee_cents
    monetize :provider_fee_cents

    def attribute_names
      [:bom_reimbursement, :subcon_fee]
    end

    #after_initialize :init
    private

    #def init
    #  self.subcon_fee_cents = 0.0
    #end
  end

  protected

  def counterparty_cut(ticket = nil)
    ticket ||= @ticket

    case ticket.my_role
      when :prov
        get_transfer_props(ticket).subcon_fee
      when :subcon
        get_transfer_props(ticket).provider_fee
      when :broker
        get_transfer_props(ticket).subcon_fee if @account.accountable == ticket.subcontractor.becomes(Organization)
        get_transfer_props(ticket).provider_fee if @account.accountable == ticket.provider.becomes(Organization)
      else
        raise "Invalid ticket.my_role received when calculating counterpaty cut"
    end

  end

  def org_charge_entries
    entries = []
    entries << PaymentToSubcontractor.new(event: @event, ticket: @ticket, amount: counterparty_cut, description: "Entry to provider owned account")
    @ticket.boms.each do |bom|
      if bom.buyer == agreement.counterparty
        entries << MaterialReimbursementToCparty.new(event: @event, ticket: @ticket, amount: bom.total_cost, description: "Material Reimbursement to subcon")
      end
    end if get_transfer_props.bom_reimbursement?
    entries
  end

  def cparty_charge_entries
    entries = []
    entries << IncomeFromProvider.new(event: @event, ticket: @ticket, amount: counterparty_cut, description: "Entry to subcontractor owned account")
    @ticket.boms.each do |bom|
      if bom.mine?
        entries << MaterialReimbursement.new(event: @event, ticket: @ticket, amount: bom.total_cost, description: "Material Reimbursement to subcon")
      end
    end if get_transfer_props.bom_reimbursement?

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


end