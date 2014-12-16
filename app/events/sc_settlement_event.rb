class ScSettlementEvent < ServiceCallEvent
  include HstoreAmount
  protected

  def update_affiliate_account(affiliate)
    billing_service = AffiliateBillingService.new(self, affiliate_mask: [affiliate])
    billing_service.execute

    # there can be multiple affiliate accounts in case this is a ticket for a broker
    billing_service.accounting_entries.each do |account, entries|
      if account.accountable.subcontrax_member? || (service_call.instance_of?(TransferredServiceCall) && service_call.provider_payment != 'cash')
        entries.each do |entry|
          entry.deposit
        end

      else
        entries.each do |entry|
          entry.clear
        end
      end
    end

  end

  def clear_accounting_entries
    service_call.entries.each do |entry|
      entry.clear if entry.is_a?(AffiliateSettlementEntry)
    end
  end

end