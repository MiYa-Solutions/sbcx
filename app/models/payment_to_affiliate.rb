class PaymentToAffiliate < AffiliateSettlementEntry
  include InitiatedConfirmableEntry

  def amount_direction
    1
  end

  has_many :events, as: :eventable

  STATUS_REJECTED = 9001

  state_machine :status do

    state :rejected, value: STATUS_REJECTED

    event :reject do
      transition :deposited => :rejected
    end

    event :clear do
      transition :deposited => :cleared
    end

    event :deposit do
      transition :confirmed => :deposited
    end

  end

  def allowed_status_events
    status_events
  end

end