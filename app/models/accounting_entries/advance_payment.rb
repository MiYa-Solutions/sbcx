class AdvancePayment < AccountingEntry
  before_create -> {
    self.status = AccountingEntry::STATUS_CLEARED
  }

  def amount_direction
    1
  end
end