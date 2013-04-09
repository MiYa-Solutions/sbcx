class ScSettlementEvent < ServiceCallEvent
  protected

  def update_affiliate_account
    billing_service = AffiliateBillingService.new(self)
    billing_service.execute

    if service_call.affiliate.subcontrax_member? || ( service_call.instance_of?(TransferredServiceCall) && service_call.provider_payment != 'cash')
      billing_service.accounting_entries.each do |entry|
        entry.deposit
      end
    else
      billing_service.accounting_entries.each do |entry|
        entry.clear
      end
    end
  end

  def clear_accounting_entries
     service_call.entries.each do |entry|
       entry.clear if entry.is_a?(AffiliateSettlementEntry)
     end
  end

end