class PaymentFromAffiliate < AffiliateSettlementEntry
  include ReceivedConfirmableEntry

  def amount_direction
    -1
  end


end