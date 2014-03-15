require 'collectible'
class CollectedEntry < AccountingEntry
  include Collectible

  STATUS_SUBMITTED = 4000

  state_machine :status, initial: :submitted do
    state :submitted, value: STATUS_SUBMITTED

    event :deposited do
      transition :submitted => :deposited
    end

    event :cleared do
      transition :deposited => :cleared
    end

  end

  def allowed_status_events
    if account.accountable.member?
      []
    else
      self.status_events & [:deposited]
    end

  end
end