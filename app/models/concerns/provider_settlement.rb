module ProviderSettlement
  extend ActiveSupport::Concern

  # State machine for ServiceCall subcontractor_status
  # status constant list:

  # todo validate that the payment string is valid

  included do

    attr_accessor :prov_settle_type
    attr_accessor :prov_settle_amount

    state_machine :provider_status, :initial => :pending, namespace: 'provider' do
      # :na - provider settlement is not applicable
      state :na, value: AffiliateSettlement::STATUS_NA
      # :pending - provider settlement has not been initiated - no affilaite payment was submitted
      state :pending, value: AffiliateSettlement::STATUS_PENDING
      # :claimed_as_settled - the provider is claiming this job was settled
      state :claimed_as_settled, value: AffiliateSettlement::STATUS_CLAIMED_AS_SETTLED
      # :settled - the full payment was received from the provider
      state :settled, value: AffiliateSettlement::STATUS_SETTLED
      # : cleared - the full payment was cleared
      state :cleared, value: AffiliateSettlement::STATUS_CLEARED
      # :claimed_p_settled - the provider claims that part of the provider owned amount was received
      state :claimed_p_settled, value: AffiliateSettlement::STATUS_CLAIMED_P_SETTLED
      # :partially_settled - the subcon confirmed that the partial payments were received
      state :partially_settled, value: AffiliateSettlement::STATUS_P_SETTLED
      # :rejected - the subcon indicates that a payment received by the contractor was rejected (check or credit card)
      state :rejected, value: AffiliateSettlement::STATUS_REJECTED
      # :disputed - the subcon indicates that he didn't receive the alleged payment by the provider
      state :disputed, value: AffiliateSettlement::STATUS_REJECTED

      after_failure do |service_call, transition|
        Rails.logger.debug { "ProviderSettlement subcon status state machine failure. Service Call errors : \n" + service_call.errors.messages.inspect + "\n The transition: " +transition.inspect }
      end

      # for cash payment, paid means cleared
      after_transition any => :settled do |sc, transition|
        if sc.provider_fully_paid?
          sc.provider_status = AffiliateSettlement::STATUS_CLEARED
          sc.save
        end
      end


      event :provider_confirmed do
        transition [:partially_settled, :claimed_p_settled, :claim_settled, :claim_p_settled] => :settled, if: ->(sc) { sc.provider_settlement_allowed? && sc.provider_fully_settled? }
        transition [:partially_settled, :claimed_p_settled, :claim_settled, :claim_p_settled] => :partially_settled, if: ->(sc) { sc.provider_settlement_allowed? && !sc.provider_fully_settled? }
      end

      event :provider_marked_as_settled do
        transition [:claimed_p_settled, :pending] => :claimed_as_settled, if: lambda { |sc| sc.provider_settlement_allowed? && sc.provider.subcontrax_member? && sc.provider_fully_settled? }
        transition [:claimed_p_settled, :pending] => :claimed_p_settled, if: lambda { |sc| sc.provider_settlement_allowed? && sc.provider.subcontrax_member? && !sc.provider_fully_settled? }
      end

      event :confirm_settled do
        transition :claimed_as_settled => :settled, if: ->(sc) { sc.provider_settlement_allowed? && sc.provider_fully_settled? }
        transition :claimed_p_settled => :partially_settled, if: ->(sc) { sc.provider_settlement_allowed? && !sc.provider_fully_settled? }
      end

      event :settle do
        transition [:rejected, :partially_settled, :pending] => :settled, if: ->(sc) {
                                                                          sc.provider_settlement_allowed? &&
                                                                              sc.provider_fully_settled?
                                                                        }
        transition [:rejected, :partially_settled, :pending] => :partially_settled, if: ->(sc) {
                                                                                    sc.provider_settlement_allowed? &&
                                                                                        !sc.provider_fully_settled?
                                                                                  }
        transition :claimed_p_settled => :claimed_p_settled, if: ->(sc) {
                                                               sc.provider_settlement_allowed? &&
                                                                   !sc.provider_fully_settled?
                                                             }
        transition :claimed_p_settled => :claimed_settled, if: ->(sc) {
                                                               sc.provider_settlement_allowed? &&
                                                                   sc.provider_fully_settled?
                                                             }
        # transition [:rejected, :claim_p_settled, :pending] => :claim_settled, if: ->(sc) {
        #                                                                       sc.provider_settlement_allowed? &&
        #                                                                           sc.provider.subcontrax_member? &&
        #                                                                           sc.provider_fully_settled?
        #                                                                     }
        # transition [:rejected, :claim_p_settled, :pending] => :claim_p_settled, if: ->(sc) {
        #                                                                         sc.provider_settlement_allowed? &&
        #                                                                             sc.provider.subcontrax_member? &&
        #                                                                             !sc.provider_fully_settled?
        #                                                                       }
      end

      event :clear do
        transition :settled => :cleared
      end

      event :cancel do
        transition :pending => :na, if: ->(sc) { sc.canceled? }
      end

      event :reopen do
        transition [:claim_settled, :settled, :cleared, :claimed_as_settled, :partially_settled, :claim_p_settled, :claimed_p_settled] => :pending
        transition :pending => :pending
        transition :na => :na
      end

      event :dispute do
        transition [:claimed_as_settled, :claimed_p_settled] => :disputed
      end

      event :update_status do
        transition :claimed_p_settled => :claimed_as_settled, if: ->(sc) { sc.provider_fully_settled? }
        transition :partially_settled => :settled, if: ->(sc) { sc.provider_fully_settled? }
      end


    end

  end

  def provider_settlement_allowed?
    !new? && !rejected? && (!allow_collection? || payment_deposited?)
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
      provider_total > 0 ? provider_total - (provider_settled_amount.abs + Money.new(current_payment.to_f * 100, provider_charge.currency)) <= 0 : false
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

  def provider_paid_entries
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

  def provider_balance
    if provider != organization
      affiliate_balance(provider)
    else
      Money.new_with_amount(0)
    end
  end


end