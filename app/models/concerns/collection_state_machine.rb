module CollectionStateMachine
  extend ActiveSupport::Concern

  STATUS_NA           = 0
  STATUS_PENDING      = 1
  STATUS_COLLECTED    = 2
  STATUS_P_COLLECTED  = 3
  STATUS_IS_DEPOSITED = 4
  STATUS_DISPUTED     = 5
  STATUS_DEPOSITED    = 6

  module ClassMethods
    def collection_status(field_name, options = {})

      state_machine field_name, options do
        state :na, value: CollectionStateMachine::STATUS_NA
        state :pending, value: CollectionStateMachine::STATUS_PENDING
        state :collected, value: CollectionStateMachine::STATUS_COLLECTED
        state :partially_collected, value: CollectionStateMachine::STATUS_P_COLLECTED
        state :is_deposited, value: CollectionStateMachine::STATUS_IS_DEPOSITED
        state :disputed, value: CollectionStateMachine::STATUS_DISPUTED
        state :deposited, value: CollectionStateMachine::STATUS_DEPOSITED

        event :collected do
          transition [:pending, :is_deposited, :partially_collected] => :collected, if: ->(sc) { sc.fully_paid? }
          transition [:pending, :is_deposited] => :partially_collected, if: ->(sc) { !sc.fully_paid? }
        end

        event :deposited do
          transition [:partially_collected, :collected, :disputed] => :is_deposited, if: ->(sc) { sc.fully_deposited? }
        end

        event :deposit_disputed do
          transition :is_deposited => :disputed
        end

        event :confirmed do
          transition :is_deposited => :deposited
        end

      end
    end
  end

end