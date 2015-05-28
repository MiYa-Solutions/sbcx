class PaymentToAffiliate < AffiliateSettlementEntry
  include InitiatedConfirmableEntry
  include InitiatedDepositableEntry

  def amount_direction
    1
  end

  def confirm_affiliate_status
    ticket.subcon_confirmed_subcon! if ticket.can_subcon_confirmed_subcon?
  end

  def dispute_affiliate_status
    ticket.subcon_disputed_subcon! if ticket.can_subcon_disputed_subcon?
  end

end