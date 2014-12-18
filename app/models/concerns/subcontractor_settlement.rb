module SubcontractorSettlement
  extend ActiveSupport::Concern

  # State machine for ServiceCall subcontractor_status
  # status constant list:
  SUBCON_STATUS_NA                 = 3000
  SUBCON_STATUS_PENDING            = 3001
  SUBCON_STATUS_CLAIM_SETTLED      = 3002
  SUBCON_STATUS_CLAIMED_AS_SETTLED = 3003
  SUBCON_STATUS_SETTLED            = 3004
  SUBCON_STATUS_CLEARED            = 3005
  SUBCON_STATUS_CLAIMED_P_SETTLED  = 3006
  SUBCON_STATUS_P_SETTLED          = 3007
  SUBCON_STATUS_CLAIM_P_SETTLED    = 3008
  SUBCON_STATUS_REJECTED           = 3009

  # todo validate that the payment string is valid

  included do

    attr_accessor :subcon_settle_type
    attr_accessor :subcon_settle_amount

    state_machine :subcontractor_status, :initial => :na, namespace: 'subcon' do
      state :na, value: SUBCON_STATUS_NA
      state :pending, value: SUBCON_STATUS_PENDING
      state :claim_settled, value: SUBCON_STATUS_CLAIM_SETTLED
      state :claimed_as_settled, value: SUBCON_STATUS_CLAIMED_AS_SETTLED
      state :settled, value: SUBCON_STATUS_SETTLED
      state :cleared, value: SUBCON_STATUS_CLEARED
      state :cleared, value: SUBCON_STATUS_CLEARED
      state :claim_p_settled, value: SUBCON_STATUS_CLAIM_P_SETTLED
      state :claimed_p_settled, value: SUBCON_STATUS_CLAIMED_P_SETTLED
      state :partially_settled, value: SUBCON_STATUS_P_SETTLED
      state :rejected, value: SUBCON_STATUS_REJECTED

      after_failure do |service_call, transition|
        Rails.logger.debug { "SubcontractorSettlement subcon status state machine failure. Errors : \n" + service_call.errors.messages.inspect + "\n The transition: " +transition.inspect }
      end

      after_transition any => :settled do |service_call, transition|
        if service_call.subcon_fully_paid?
          service_call.subcontractor_status = SUBCON_STATUS_CLEARED
          service_call.save
        end
      end

      event :subcon_confirmed do
        transition [:partially_settled, :claimed_p_settled, :claim_settled, :claim_p_settled] => :settled, if: ->(sc) { sc.subcon_settlement_allowed? && sc.subcon_fully_settled? }
        transition [:partially_settled, :claimed_p_settled, :claim_settled, :claim_p_settled] => :partially_settled, if: ->(sc) { sc.subcon_settlement_allowed? && !sc.subcon_fully_settled? }
      end

      event :subcon_marked_as_settled do
        transition [:claimed_p_settled, :pending] => :claimed_as_settled, if: ->(sc) { sc.subcontractor.subcontrax_member? && sc.subcon_settlement_allowed? && sc.subcon_fully_settled? }
        transition :pending => :claimed_p_settled, if: ->(sc) { sc.subcontractor.subcontrax_member? && sc.subcon_settlement_allowed? && !sc.subcon_fully_settled? }
      end

      event :confirm_settled do
        transition :claimed_as_settled => :settled, if: ->(sc) { sc.subcon_settlement_allowed? && sc.subcon_fully_settled? }
      end

      event :settle do
        transition [:rejected, :partially_settled, :pending] => :settled, if: ->(sc) {
                                                               sc.subcon_settlement_allowed? &&
                                                                   !sc.subcontractor.subcontrax_member? &&
                                                                       sc.subcon_fully_settled?
                                                             }
        transition [:rejected, :partially_settled, :pending] => :partially_settled, if: ->(sc) {
                                                                         sc.subcon_settlement_allowed? &&
                                                                             !sc.subcontractor.subcontrax_member? &&
                                                                                 !sc.subcon_fully_settled?
                                                                       }
        transition [:rejected, :claim_p_settled, :pending] => :claim_settled, if: ->(sc) {
                                                                   sc.subcon_settlement_allowed? &&
                                                                       sc.subcontractor.subcontrax_member? &&
                                                                       sc.subcon_fully_settled?
                                                                 }
        transition [:rejected, :claim_p_settled, :pending] => :claim_p_settled, if: ->(sc) {
                                                                     sc.subcon_settlement_allowed? &&
                                                                         sc.subcontractor.subcontrax_member? &&
                                                                         !sc.subcon_fully_settled?
                                                                   }
      end

      event :clear do
        transition [:partially_settled, :settled] => :cleared, if: ->(sc) { sc.subcon_fully_paid? }
        transition :partially_settled => :partially_settled, if: ->(sc) { sc.subcon_fully_paid? }
      end

      event :deposited do
        transition any => :cleared, if: ->(sc) { sc.subcon_fully_paid? }
      end

      event :reject do
        transition [:settled, :partially_settled] => :rejected
      end

      event :cancel do
        transition :pending => :na
      end

    end

  end

  def subcon_settlement_allowed?
    raise NotImplemented.new ('You probably forgot to implement subcon_settlement_allowed when including SubcontractorSettlement')
  end

  def subcon_settle_money
    Money.new(subcon_settle_amount.to_f * 100)
  end

  def subcon_fully_confirmed?
    subcon_payments.where(status: [ConfirmableEntry::STATUS_SUBMITTED, ConfirmableEntry::STATUS_DISPUTED]).size > 0

  end

  def subcon_fully_settled?
    current_payment = subcon_settle_amount || 0

    if self.canceled?
      true
    elsif self.work_done?
      subcon_total > 0 ? subcon_total - (subcon_settled_amount + Money.new(current_payment.to_f * 100, subcon_charge.currency)) <= 0 : false
    else
      false
    end

  end

  def subcon_charge
    Money.new(subcon_entries.where(type: ['PaymentToSubcontractor', 'MaterialReimbursementToCparty']).sum(:amount_cents)).abs
  end

  def subcon_total
    (subcon_charge - subcon_reimbursements).abs
  end

  def subcon_reimbursements
    Money.new(subcon_entries.where(type: ['ReimbursementForAmexPayment',
                                          'ReimbursementForCashPayment',
                                          'ReimbursementForChequePayment',
                                          'ReimbursementForCreditPayment']).sum(:amount_cents))
  end

  def subcon_payments
    subcon_entries.where(type: AffiliateSettlementEntry.descendants.map(&:name))
  end

  def subcon_paid_entries
    subcon_payments.where(status: [PaymentToAffiliate::STATUS_CLEARED])
  end

  def subcon_paid_amount
    Money.new(subcon_paid_entries.sum(:amount_cents))
  end

  def subcon_fully_paid?
    subcon_total - subcon_paid_amount == Money.new(0)
  end


  def subcon_settled_entries
    subcon_payments.where('status NOT IN (?)', [ConfirmableEntry::STATUS_DISPUTED, PaymentToAffiliate::STATUS_REJECTED])
  end

  def subcon_settled_amount
    Money.new(subcon_settled_entries.sum(:amount_cents))
  end


end