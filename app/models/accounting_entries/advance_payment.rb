class AdvancePayment < AccountingEntry

  def self.exclude_agreement?
    true
  end

  before_create -> {
    self.status = AccountingEntry::STATUS_CLEARED
  }

  def amount_direction
    1
  end
end