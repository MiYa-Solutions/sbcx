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
      when ScProviderCollectedEvent.name
        true
      else
        false
    end
  end

  protected

  def cparty_collection_entries
    entries = []

    collection_props = {
        status:      AccountingEntry::STATUS_CLEARED,
        amount:      @event.amount,
        collector:   @event.collector,
        ticket:      @ticket,
        event:       @event,
        agreement:   agreement,
        description: I18n.t("payment.#{@ticket.payment_type}.description", ticket: @ticket.id).html_safe
    }

    fee_props = { status:      AccountingEntry::STATUS_CLEARED,
                  ticket:      @ticket,
                  event:       @event,
                  agreement:   agreement,
                  description: I18n.t("payment_fee.#{@ticket.payment_type}.description", ticket: @ticket.id).html_safe
    }

    case @ticket.payment_type
      when 'cash'
        entries << CashCollectionForProvider.new(collection_props)
        fee_props[:amount] = cash_fee
        entries << CashPaymentFee.new(fee_props) unless cash_rate.nil? || cash_rate.delete(',').to_f == 0

      when 'credit_card'
        fee_props[:amount] = credit_fee
        entries << CreditCardCollectionForProvider.new(collection_props)
        entries << CreditPaymentFee.new(fee_props) unless credit_rate.nil? || credit_rate.delete(',').to_f == 0

      when 'amex_credit_card'
        fee_props[:amount] = amex_fee
        entries << AmexCollectionForProvider.new(collection_props)
        entries << AmexPaymentFee.new(fee_props) unless amex_rate.nil? || amex_rate.delete(',').to_f == 0

      when 'cheque'
        fee_props[:amount] = cheque_fee
        entries << ChequeCollectionForProvider.new(collection_props)
        entries << ChequePaymentFee.new(fee_props) unless cheque_rate.nil? || cheque_rate.delete(',').to_f == 0


      else
        raise "#{self.class.name}: Unexpected payment type (#{@ticket.payment_type}) when processing the event"

    end

    entries
  end

  def cparty_settlement_entries
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

    [CanceledJobAdjustment.new(agreement: agreement, event: @event, ticket: @ticket, amount: -(original_entry.amount + adjustment), description: "Entry to provider owned account")]
  end

  def org_cancellation_entries
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

    [CanceledJobAdjustment.new(agreement: agreement, event: @event, ticket: @ticket, amount: -(original_entry.amount + adjustment), description: "Entry to provider owned account")]
  end

  def org_collection_entries
    entries          = []
    collection_props = { status:      AccountingEntry::STATUS_CLEARED,
                         amount:      @event.amount,
                         amount:      @event.collector,
                         ticket:      @ticket,
                         event:       @event,
                         agreement:   agreement,
                         description: I18n.t("payment.#{@ticket.payment_type}.description", ticket: @ticket.id).html_safe }

    fee_props = { status:      AccountingEntry::STATUS_CLEARED,
                  ticket:      @ticket,
                  event:       @event,
                  agreement:   agreement,
                  description: I18n.t("payment_reimbursement.#{@ticket.payment_type}.description", ticket: @ticket.id).html_safe }


    case @ticket.payment_type
      when 'cash'
        entries << CashCollectionFromSubcon.new(collection_props)

        fee_props[:amount] = cash_fee
        entries << ReimbursementForCashPayment.new(fee_props) unless cash_rate.nil? || cash_rate.delete(',').to_f == 0
      when 'credit_card'
        fee_props[:amount] = credit_fee
        entries << CreditCardCollectionFromSubcon.new(collection_props)
        entries << ReimbursementForCreditPayment.new(fee_props) unless credit_rate.nil? || credit_rate.delete(',').to_f == 0
      when 'amex_credit_card'
        fee_props[:amount] = amex_fee
        entries << AmexCollectionFromSubcon.new(collection_props)
        entries << ReimbursementForAmexPayment.new(fee_props) unless amex_rate.nil? || amex_rate.delete(',').to_f == 0
      when 'cheque'
        fee_props[:amount] = cheque_fee
        entries << ChequeCollectionFromSubcon.new(collection_props)
        entries << ReimbursementForChequePayment.new(fee_props) unless cheque_rate.nil? || cheque_rate.delete(',').to_f == 0

      else

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
        agreement:   agreement,
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
    case @ticket.my_role
      when :prov
        org_cancellation_entries
      when :subcon
        cparty_cancellation_entries
      else
        raise "Unrecognized role when creating profit split entries"
    end

  end
end

Dir["#{Rails.root}/app/models/posting_rules/affiliate/*.rb"].each do |file|
  require_dependency file
end
