class CustomerPayment < AccountingEntry

  has_many :events, as: :eventable

  STATUS_REJECTED = 9001

  state_machine :status, initial: :pending do

    event :reject do
      transition [:pending, :deposited] => :rejected
    end

    event :clear do
      transition [:rejected, :pending, :deposited] => :cleared
    end

  end

end