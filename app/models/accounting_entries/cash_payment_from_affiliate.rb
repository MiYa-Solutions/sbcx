class CashPaymentFromAffiliate < AffiliateSettlementEntry
  def amount_direction
    -1
  end
end