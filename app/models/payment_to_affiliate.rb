class PaymentToAffiliate < AffiliateSettlementEntry
  include InitiatedConfirmableEntry

  def amount_direction
    1
  end

  def confirm_affiliate_status
    ticket.subcon_confirmed_subcon! if ticket.can_subcon_confirmed_subcon?
  end

end