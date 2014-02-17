module InitiatedConfirmableEntry
  extend ActiveSupport::Concern
  extend ConfirmableEntry

  included do
    state_machine :status, initial: :submitted do
      state :submitted, value: ConfirmableEntry::STATUS_SUBMITTED
      state :confirmed, value: ConfirmableEntry::STATUS_CONFIRMED
      state :disputed, value: ConfirmableEntry::STATUS_DISPUTED

      event :confirmed do
        transition [:submitted, :disputed] => :confirmed
      end

      event :disputed do
        transition :submitted => :disputed
      end

    end
  end

end