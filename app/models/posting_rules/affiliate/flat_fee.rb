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
    column :prov_bom_reimbursement, :boolean
    column :subcon_fee_cents, :integer, 0
    column :subcon_fee_currency, :string
    column :provider_fee_cents, :integer, 0
    column :provider_fee_currency, :string
    monetize :subcon_fee_cents
    monetize :provider_fee_cents

    def attribute_names
      [:bom_reimbursement, :prov_bom_reimbursement, :subcon_fee, :provider_fee]
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
    amount = nil

    case ticket.my_role
      when :prov
        amount = get_transfer_props(ticket).subcon_fee
      when :subcon
        amount = get_transfer_props(ticket).provider_fee
      when :broker
        amount = get_transfer_props(ticket).subcon_fee if @account.accountable == ticket.subcontractor.becomes(Organization)
        amount = get_transfer_props(ticket).provider_fee if @account.accountable == ticket.provider.becomes(Organization)

      else
        raise "Invalid ticket.my_role received when calculating counterpaty cut"
    end
    amount

  end

  def org_charge_entries
    entries = []
    entries << PaymentToSubcontractor.new(agreement:   agreement,
                                          event:       @event,
                                          ticket:      @ticket,
                                          amount:      counterparty_cut,
                                          description: "Entry to provider owned account")
    @ticket.boms.each do |bom|
      if bom.buyer == agreement.counterparty
        entries << MaterialReimbursementToCparty.new(agreement:   agreement,
                                                     event:       @event,
                                                     ticket:      @ticket,
                                                     amount:      bom.total_cost,
                                                     description: "Material Reimbursement to subcon")
      end
    end if get_transfer_props.bom_reimbursement?
    entries
  end

  def cparty_charge_entries
    entries = []
    entries << IncomeFromProvider.new(agreement: agreement, event: @event, ticket: @ticket, amount: counterparty_cut, description: "Entry to subcontractor owned account")
    @ticket.boms.each do |bom|
      if bom.mine?
        entries << MaterialReimbursement.new(agreement: agreement, event: @event, ticket: @ticket, amount: bom.total_cost, description: "Material Reimbursement to subcon")
      end
    end if get_transfer_props.prov_bom_reimbursement?

    entries
  end


end