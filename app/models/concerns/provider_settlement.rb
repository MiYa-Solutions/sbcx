module ProviderSettlement
  extend ActiveSupport::Concern

  # State machine for ServiceCall subcontractor_status
  # status constant list:

  # todo validate that the payment string is valid

  included do

    attr_accessor :prov_settle_type
    attr_accessor :prov_settle_amount

    state_machine :provider_status, :initial => :pending, namespace: 'provider' do
      state :na, value: AffiliateSettlement::STATUS_NA
      state :pending, value: AffiliateSettlement::STATUS_PENDING
      state :claim_settled, value: AffiliateSettlement::STATUS_CLAIM_SETTLED
      state :claimed_as_settled, value: AffiliateSettlement::STATUS_CLAIMED_AS_SETTLED
      state :settled, value: AffiliateSettlement::STATUS_SETTLED
      state :cleared, value: AffiliateSettlement::STATUS_CLEARED
      state :cleared, value: AffiliateSettlement::STATUS_CLEARED
      state :claim_p_settled, value: AffiliateSettlement::STATUS_CLAIM_P_SETTLED
      state :claimed_p_settled, value: AffiliateSettlement::STATUS_CLAIMED_P_SETTLED
      state :partially_settled, value: AffiliateSettlement::STATUS_P_SETTLED
      state :rejected, value: AffiliateSettlement::STATUS_REJECTED

      after_failure do |service_call, transition|
        Rails.logger.debug { "ProviderSettlement subcon status state machine failure. Service Call errors : \n" + service_call.errors.messages.inspect + "\n The transition: " +transition.inspect }
      end

      # for cash payment, paid means cleared
      after_transition any => :settled do |sc, transition|
        if service_call.provider_fully_paid?
          service_call.provider_status = AffiliateSettlement::STATUS_CLEARED
          service_call.save
        end
      end


      event :provider_confirmed do
        transition [:partially_settled, :claimed_p_settled, :claim_settled, :claim_p_settled] => :settled, if: ->(sc) { sc.provider_settlement_allowed? && sc.provider_fully_settled? }
        transition [:partially_settled, :claimed_p_settled, :claim_settled, :claim_p_settled] => :partially_settled, if: ->(sc) { sc.provider_settlement_allowed? && !sc.provider_fully_settled? }
      end

      event :provider_marked_as_settled do
        transition :pending => :claimed_as_settled, if: lambda { |sc| sc.provider_settlement_allowed? && sc.provider.subcontrax_member? && sc.provider_fully_settled?}
        transition :pending => :claimed_p_settled, if: lambda { |sc| sc.provider_settlement_allowed? && sc.provider.subcontrax_member? && !sc.provider_fully_settled? }
      end

      event :confirm_settled do
        transition :claimed_as_settled => :settled, if: lambda { |sc| sc.provider_settlement_allowed? }
      end

      event :settle do
        transition :pending => :settled, if: lambda { |sc| sc.provider_settlement_allowed? && !sc.provider.subcontrax_member? }
        transition :pending => :claim_settled, if: lambda { |sc| sc.provider_settlement_allowed? && sc.provider.subcontrax_member? }
      end

      event :clear do
        transition :settled => :cleared
      end

      event :cancel do
        transition :pending => :na, if: ->(sc) { sc.canceled? }
      end

    end

  end

  def subcon_settlement_allowed?
    raise NotImplemented.new ('You probably forgot to implement subcon_settlement_allowed when including SubcontractorSettlement')
  end

  def provider_settle_money
    Money.new(provider_settle_amount.to_f * 100)
  end

  def provider_fully_confirmed?
    subcon_payments.where(status: [ConfirmableEntry::STATUS_SUBMITTED, ConfirmableEntry::STATUS_DISPUTED]).size > 0

  end

  def provider_fully_settled?
    current_payment = prov_settle_amount || 0

    if self.canceled?
      true
    elsif self.work_done?
      provider_total > 0 ? provider_total - (provider_settled_amount + Money.new(current_payment.to_f * 100, provider_charge.currency)) <= 0 : false
    else
      false
    end

  end

  def provider_charge
    Money.new(provider_entries.where(type: ['IncomeFromProvider', 'MaterialReimbursement']).sum(:amount_cents)).abs
  end

  def provider_total
    (provider_charge - provider_reimbursements).abs
  end

  def provider_reimbursements
    Money.new(provider_entries.where(type: ['AmexPaymentFee',
                                          'CashPaymentFee',
                                          'ChequePaymentFee',
                                          'CreditPaymentFee']).sum(:amount_cents))
  end

  def provider_payments
    provider_entries.where(type: AffiliateSettlementEntry.descendants.map(&:name))
  end

  def subcon_paid_entries
    provider_payments.where(status: [PaymentToAffiliate::STATUS_CLEARED])
  end

  def provider_paid_amount
    Money.new(provider_paid_entries.sum(:amount_cents))
  end

  def provider_fully_paid?
    provider_total - provider_paid_amount == Money.new(0)
  end


  def provider_settled_entries
    provider_payments.where('status NOT IN (?)', [ConfirmableEntry::STATUS_DISPUTED, PaymentToAffiliate::STATUS_REJECTED])
  end

  def provider_settled_amount
    Money.new(provider_settled_entries.sum(:amount_cents))
  end


end