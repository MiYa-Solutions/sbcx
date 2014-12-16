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

      after_failure do |service_call, transition|
        Rails.logger.debug { "Service Call subcon status state machine failure. Service Call errors : \n" + service_call.errors.messages.inspect + "\n The transition: " +transition.inspect }
      end

      after_transition any => :settled do |service_call, transition|
        if service_call.subcon_payment == 'cash'
          service_call.subcontractor_status = SUBCON_STATUS_CLEARED
          service_call.save
        end
      end

      event :subcon_confirmed do
        transition :claim_settled => :settled, if: ->(sc) { !sc.canceled? && sc.subcon_settlement_allowed? }
      end

      event :subcon_marked_as_settled do
        transition :pending => :claimed_as_settled, if: ->(sc) { !sc.canceled? && sc.subcontractor.subcontrax_member? && sc.subcon_settlement_allowed? }
      end

      event :confirm_settled do
        transition :claimed_as_settled => :settled, if: ->(sc) { !sc.canceled? && sc.subcon_settlement_allowed? }
      end

      event :settle do
        transition :pending => :settled, if: ->(sc) { !sc.canceled? && sc.subcon_settlement_allowed? && sc.work_done? && !sc.subcontractor.subcontrax_member? }
        transition :pending => :claim_settled, if: ->(sc) { !sc.canceled? && sc.subcon_settlement_allowed? && sc.work_done? && sc.subcontractor.subcontrax_member? }
      end

      event :clear do
        transition :settled => :cleared
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

end