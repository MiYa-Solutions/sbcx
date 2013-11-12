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

class ProfitSplit < AffiliatePostingRule

  validates_presence_of :rate, :rate_type
  validates_numericality_of :rate

  def rate_types
    [:percentage]
  end


  protected

  def counterparty_cut
    @ticket.total_profit * (rate / 100.0)
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

  def org_charge_entries
    entries = []
    entries << PaymentToSubcontractor.new(event: @event, ticket: @ticket, amount: counterparty_cut, description: "Entry to provider owned account")
    @ticket.boms.each do |bom|
      if bom.buyer == agreement.counterparty
        entries << MaterialReimbursementToCparty.new(event: @event, ticket: @ticket, amount: bom.total_cost, description: "Material Reimbursement to subcon")
      end
    end
    entries
  end

  def cparty_charge_entries
    entries = []
    entries << IncomeFromProvider.new(event: @event, ticket: @ticket, amount: counterparty_cut, description: "Entry to subcontractor owned account")
    @ticket.boms.each do |bom|
      if bom.mine?
        entries << MaterialReimbursement.new(event: @event, ticket: @ticket, amount: bom.total_cost, description: "Material Reimbursement to subcon")
      end
    end

    entries
  end


end
