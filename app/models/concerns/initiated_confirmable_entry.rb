module InitiatedConfirmableEntry
  extend ActiveSupport::Concern


  included do
    STATUS_SUBMITTED = 1000
    STATUS_CONFIRMED = 1001
    STATUS_DISPUTED  = 1002
    STATUS_CANCELED  = 1003
    state_machine :status, initial: :submitted do
      state :submitted, value: STATUS_SUBMITTED
      state :confirmed, value: STATUS_CONFIRMED
      state :disputed, value: STATUS_DISPUTED
      state :canceled, value: STATUS_CANCELED

      event :confirmed do
        transition [:submitted, :disputed] => :confirmed
      end

      event :disputed do
        transition :submitted => :disputed
      end

      event :cancel do
        transition :disputed => :canceled
      end

    end
  end

end