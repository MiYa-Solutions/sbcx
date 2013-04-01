class ScCompletionEvent < ServiceCallEvent

  protected
  def invoke_affiliate_billing
    if service_call.affiliate.present?
      aff_billing = AffiliateBillingService.new(self)
      aff_billing.execute

      aff_billing.accounting_entries.each do |entry|
        entry.clear
      end
    end
  end


end