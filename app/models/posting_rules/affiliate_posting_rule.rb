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

class AffiliatePostingRule < PostingRule

  def get_transfer_props(ticket = nil)
    ticket ||= @ticket
    if ticket
      white_list = self.class::TransferProperties.new.attribute_names
      props      = ticket.properties.keep_if { |key, val| white_list.include? key.to_sym }
      self.class::TransferProperties.new(props)
    else
      self.class::TransferProperties.new
    end
  end

  class TransferProperties < TicketProperties
  end


  # To change this template use File | Settings | File Templates.
  # todo implement timebound check
  def applicable?(event)
    case event.class.name
      when ServiceCallCompletedEvent.name
        true
      when ServiceCallCompleteEvent.name
        true
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
      when ScProviderCanceledEvent.name
        true
      when ScCollectEvent.name
        true
      when ServiceCallPaidEvent.name
        true
      when ScCollectedEvent.name
        true
      when ScProviderCollectedEvent.name
        true
      when ScCollectedByEmployeeEvent.name
        true
      else
        false
    end
  end

  protected

  def cparty_collection_entries
    entries = []

    collection_props = {
        amount:      @event.amount,
        collector:   @event.collector,
        ticket:      @ticket,
        event:       @event,
        notes:       @event.notes,
        agreement:   agreement,
        description: I18n.t("payment.#{@ticket.payment_type}.description", ticket: @ticket.id).html_safe
    }

    fee_props = { status:      AccountingEntry::STATUS_CLEARED,
                  ticket:      @ticket,
                  event:       @event,
                  agreement:   agreement,
                  description: I18n.t("payment_fee.#{@ticket.payment_type}.description", ticket: @ticket.id).html_safe
    }

    case @event.payment_type
      when 'cash'
        entries << CashCollectionForProvider.new(collection_props) if collected_by_me?
        fee_props[:amount] = cash_fee
        entries << CashPaymentFee.new(fee_props) unless cash_rate.nil? || cash_rate.delete(',').to_f == 0

      when 'credit_card'
        fee_props[:amount] = credit_fee
        entries << CreditCardCollectionForProvider.new(collection_props) if collected_by_me?
        entries << CreditPaymentFee.new(fee_props) unless credit_rate.nil? || credit_rate.delete(',').to_f == 0

      when 'amex_credit_card'
        fee_props[:amount] = amex_fee
        entries << AmexCollectionForProvider.new(collection_props) if collected_by_me?
        entries << AmexPaymentFee.new(fee_props) unless amex_rate.nil? || amex_rate.delete(',').to_f == 0

      when 'cheque'
        fee_props[:amount] = cheque_fee if collected_by_me?
        entries << ChequeCollectionForProvider.new(collection_props)
        entries << ChequePaymentFee.new(fee_props) unless cheque_rate.nil? || cheque_rate.delete(',').to_f == 0


      else
        raise "#{self.class.name}: Unexpected payment type (#{@ticket.payment_type}) when processing the event"

    end

    entries
  end

  def collected_by_me?
    @event.collector.instance_of?(User) && @event.collector.organization == @account.organization ||
        @event.collector.becomes(Organization) == @account.organization || @ticket.my_role == :broker
  end

  def cparty_settlement_entries
    result = []

    charge_amount    = AccountingEntry.where(type: IncomeFromProvider, ticket_id: @ticket.id).sum(:amount_cents)
    bom_reimu_amount = AccountingEntry.where(type: MaterialReimbursement, ticket_id: @ticket.id).sum(:amount_cents)
    payment_fee      = AccountingEntry.where(type: ['CashPaymentFee', 'CreditPaymentFee', 'AmexPaymentFee', 'ChequePaymentFee'], ticket_id: @ticket.id).sum(:amount_cents)

    total = Money.new(charge_amount + bom_reimu_amount + payment_fee)


    case @ticket.provider_payment
      when 'cash'
        result << CashPaymentFromAffiliate.new(agreement: agreement, event: @event, ticket: @ticket, amount: total.abs, description: "Entry to provider owned account")
      when 'credit_card'
        result << CreditPaymentFromAffiliate.new(agreement: agreement, event: @event, ticket: @ticket, amount: total.abs, description: "Entry to provider owned account")
      when 'amex_credit_card'
        result << AmexPaymentFromAffiliate.new(agreement: agreement, event: @event, ticket: @ticket, amount: total.abs, description: "Entry to provider owned account")
      when 'cheque'
        result << ChequePaymentFromAffiliate.new(agreement: agreement, event: @event, ticket: @ticket, amount: total.abs, description: "Entry to provider owned account")
      else

    end

    result

  end

  def cparty_cancellation_entries
    entry                = AccountingEntry.where(type: IncomeFromProvider, ticket_id: @ticket.id).first
    original_entry_cents = AccountingEntry.where(type: IncomeFromProvider, ticket_id: @ticket.id).sum(:amount_cents)
    original_entry_ccy   = entry ? entry.amount_currency : Money.default_currency.to_s

    fees = AccountingEntry.where(type:      ['CashPaymentFee',
                                             'CreditPaymentFee',
                                             'AmexPaymentFee',
                                             'ChequePaymentFee',
                                             'MaterialReimbursement'
                                            ],
                                 ticket_id: @ticket.id).sum(:amount_cents)

    [CanceledJobAdjustment.new(agreement: agreement, event: @event, ticket: @ticket, amount_cents: -(original_entry_cents + fees), amount_currency: original_entry_ccy, description: 'Adjustment due to a job being canceled')]
  end

  def org_cancellation_entries
    entry                = AccountingEntry.where(type: PaymentToSubcontractor, ticket_id: @ticket.id).first
    original_entry_cents = AccountingEntry.where(type: PaymentToSubcontractor, ticket_id: @ticket.id).sum(:amount_cents)
    original_entry_ccy   = entry ? entry.amount_currency : Money.default_currency.to_s

    fees = AccountingEntry.where(type:      ['ReimbursementForCashPayment',
                                             'ReimbursementForCreditPayment',
                                             'ReimbursementForAmexPayment',
                                             'ReimbursementForChequePayment',
                                             'MaterialReimbursementToCparty'
                                            ],
                                 ticket_id: @ticket.id).sum(:amount_cents)


    [CanceledJobAdjustment.new(agreement: agreement, event: @event, ticket: @ticket, amount_cents: -(original_entry_cents + fees), amount_currency: original_entry_ccy, description: "Entry to provider owned account")]
  end

  def org_collection_entries
    OrgCollectionEntryFactory.new(event:        @event,
                                  ticket:       @ticket,
                                  agreement:    agreement,
                                  posting_rule: self,
                                  account:      @account).generate
  end

  def org_settlement_entries
    result = []

    charge_amount    = AccountingEntry.where(type: PaymentToSubcontractor, ticket_id: @ticket.id).sum(:amount_cents)
    bom_reimu_amount = AccountingEntry.where(type: MaterialReimbursementToCparty, ticket_id: @ticket.id).sum(:amount_cents)
    payment_fee      = AccountingEntry.where(type: ['ReimbursementForCashPayment', 'ReimbursementForCreditPayment', 'ReimbursementForAmexPayment', 'ReimbursementForChequePayment'], ticket_id: @ticket.id).sum(:amount_cents)

    total = Money.new(charge_amount + bom_reimu_amount + payment_fee)


    case @ticket.subcon_payment
      when 'cash'
        result << CashPaymentToAffiliate.new(agreement: agreement, event: @event, ticket: @ticket, amount: total.abs, description: "Entry to provider owned account")
      when 'credit_card'
        result << CreditPaymentToAffiliate.new(agreement: agreement, event: @event, ticket: @ticket, amount: total.abs, description: "Entry to provider owned account")
      when 'amex_credit_card'
        result << AmexPaymentToAffiliate.new(agreement: agreement, event: @event, ticket: @ticket, amount: total.abs, description: "Entry to provider owned account")
      when 'cheque'
        result << ChequePaymentToAffiliate.new(agreement: agreement, event: @event, ticket: @ticket, amount: total.abs, description: "Entry to provider owned account")
      else

    end

    result

  end

  def cparty_payment_entries
    entries = []

    fee_props = {
        status:      AccountingEntry::STATUS_CLEARED,
        ticket:      @ticket,
        event:       @event,
        agreement:   agreement,
        description: I18n.t("payment_fee.#{@ticket.payment_type}.description", ticket: @ticket.id).html_safe
    }

    case @event.payment_type
      when 'cash'
        fee_props[:amount] = cash_fee
        entries << CashPaymentFee.new(fee_props) unless cash_rate.nil? || cash_rate.delete(',').to_f == 0.0

      when 'credit_card'
        fee_props[:amount] = credit_fee
        entries << CreditPaymentFee.new(fee_props) unless credit_rate.nil? || credit_rate.delete(',').to_f == 0.0

      when 'amex_credit_card'
        fee_props[:amount] = amex_fee
        entries << AmexPaymentFee.new(fee_props) unless amex_rate.nil? || amex_rate.delete(',').to_f == 0.0

      when 'cheque'
        fee_props[:amount] = cheque_fee
        entries << ChequePaymentFee.new(fee_props) unless cheque_rate.nil? || cheque_rate.delete(',').to_f == 0.0
      else
        raise "#{self.class.name}: Unexpected payment type (#{@event.payment_type}) when processing the event"
    end

    entries
  end

  def org_payment_entries
    entries   = []
    fee_props = {
        status:      AccountingEntry::STATUS_CLEARED,
        ticket:      @ticket,
        event:       @event,
        agreement:   agreement,
        description: I18n.t("payment_reimbursement.#{@ticket.payment_type}.description", ticket: @ticket.id).html_safe
    }


    case @event.payment_type
      when 'cash'
        fee_props[:amount] = cash_fee
        entries << ReimbursementForCashPayment.new(fee_props) unless cash_rate.nil? || cash_rate.delete(',').to_f == 0.0
      when 'credit_card'
        fee_props[:amount] = credit_fee
        entries << ReimbursementForCreditPayment.new(fee_props) unless credit_rate.nil? || credit_rate.delete(',').to_f == 0.0
      when 'amex_credit_card'
        fee_props[:amount] = amex_fee
        entries << ReimbursementForAmexPayment.new(fee_props) unless amex_rate.nil? || amex_rate.delete(',').to_f == 0.0
      when 'cheque'
        fee_props[:amount] = cheque_fee
        entries << ReimbursementForChequePayment.new(fee_props) unless cheque_rate.nil? || cheque_rate.delete(',').to_f == 0.0
      else
    end
    entries
  end

  def charge_entries
    case @account.accountable
      when @ticket.subcontractor.becomes(Organization)
        org_charge_entries
      when @ticket.provider.becomes(Organization)
        cparty_charge_entries
      else
        raise "The account beneficiary (name: '#{@account.accountable.name}', type: #{@account.accountable_type}) is neither the provider or subcontractor"
    end
  end

  def collection_entries
    case @account.accountable
      when @ticket.subcontractor.becomes(Organization)
        org_collection_entries
      when @ticket.provider.becomes(Organization)
        cparty_collection_entries
      else
        raise "The account beneficiary (name: '#{@account.accountable.name}', type: #{@account.accountable_type}) is neither the provider or subcontractor"
    end
  end

  def payment_entries
    case @account.accountable
      when @ticket.subcontractor.becomes(Organization)
        org_payment_entries
      when @ticket.provider.becomes(Organization)
        cparty_payment_entries
      else
        raise "The account beneficiary (name: '#{@account.accountable.name}', type: #{@account.accountable_type}) is neither the provider or subcontractor"
    end
  end

  def settlement_entries
    case @account.accountable
      when @ticket.subcontractor.becomes(Organization)
        org_settlement_entries
      when @ticket.provider.becomes(Organization)
        cparty_settlement_entries
      else
        raise "The account beneficiary (name: '#{@account.accountable.name}', type: #{@account.accountable_type}) is neither the provider or subcontractor"
    end

  end

  def cancellation_entries
    case @account.accountable
      when @ticket.subcontractor.becomes(Organization)
        org_cancellation_entries
      when @ticket.provider.becomes(Organization)
        cparty_cancellation_entries
      else
        raise "Unrecognized role when creating profit split entries"
    end

  end
end

Dir["#{Rails.root}/app/models/posting_rules/affiliate/*.rb"].each do |file|
  require_dependency file
end
