class DepositEntry < AccountingEntry

  #STATUS_DISPUTED = 7001
  #state_machine :status, initial: :pending do
  #  state :pending, value: STATUS_DEPOSITED
  #  state :confirmed, value: STATUS_CLEARED
  #  state :disputed, value: STATUS_DISPUTED
  #
  #  event :confirm do
  #    transition [:pending, :disputed] => :confirmed
  #  end
  #
  #  event :dispute do
  #    transition :pending => :disputed
  #  end
  #end
end