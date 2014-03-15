module ReceivedConfirmableEntry
  extend ActiveSupport::Concern
  extend ConfirmableEntry

  included do
    state_machine :status, initial: :submitted do
      state :submitted, value: ConfirmableEntry::STATUS_SUBMITTED
      state :disputed, value: ConfirmableEntry::STATUS_DISPUTED
      state :confirmed, value: ConfirmableEntry::STATUS_CONFIRMED

      event :dispute do
        transition :submitted => :disputed
      end

      event :confirm do
        transition [:submitted, :disputed] => :confirmed
      end

    end


  end

end