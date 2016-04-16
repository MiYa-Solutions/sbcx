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

  def allowed_status_events
    if account.accountable.member?
      []
    else
      self.status_events
    end

  end

end