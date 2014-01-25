class CustomerPayment < AccountingEntry

  STATUS_REJECTED = 9001

  state_machine :status, initial: :pending do

    event :reject do
      transition [:pending, :deposited] => :rejected
    end

    event :clear do
      transition [:rejected, :pending, :deposited] => :cleared
    end

  end

  # To change this template use File | Settings | File Templates.
end