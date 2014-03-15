class RejectedPayment < AccountingEntry
  def amount_direction
    1
  end
end