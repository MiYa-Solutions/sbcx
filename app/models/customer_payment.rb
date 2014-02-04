require 'collectible'
class CustomerPayment < AccountingEntry
  include Collectible

  has_many :events, as: :eventable

  STATUS_REJECTED = 9001

  state_machine :status, initial: :pending do

    state :rejected, value: STATUS_REJECTED

    event :reject do
      transition [:pending, :deposited] => :rejected
    end

    event :clear do
      transition [:pending, :deposited] => :cleared
    end

    event :deposit do
      transition :pending => :deposited
    end

  end

end