module ReceivedConfirmableEntry
  extend ActiveSupport::Concern

  included do
    STATUS_SUBMITTED = 2000
    STATUS_DISPUTED  = 2001
    STATUS_CANCELED  = 2002
    state_machine :status, initial: :submitted do
      state :submitted, value: STATUS_SUBMITTED
      state :disputed, value: STATUS_DISPUTED
      state :canceled, value: STATUS_CANCELED

      event :dispute do
        transition :submitted => :disputed
      end

      event :confirm do
        transition [:submitted, :disputed] => :confirmed
      end

      event :canceled do
        transition :disputed => :canceled
      end

    end


  end

end