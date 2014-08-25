class AdvancePayment < AccountingEntry
  after_create ->(e) {e.status = AccountingEntry::STATUS_CLEARED}
  def amount_direction
    1
  end
end