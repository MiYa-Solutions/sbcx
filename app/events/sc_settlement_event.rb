class ScSettlementEvent < ServiceCallEvent
  include HstoreAmount
  protected

  def update_affiliate_account(affiliate)
    billing_service = AffiliateBillingService.new(self, affiliate_mask: [affiliate])
    billing_service.execute
    update_matching_entry(billing_service.accounting_entries.values.flatten)
  end

  def clear_accounting_entries
    service_call.entries.each do |entry|
      entry.clear if entry.is_a?(AffiliateSettlementEntry)
    end
  end

  private

  def update_matching_entry(entries)
    if triggering_event_id
      matching_entry = AccountingEntry.where(event_id: triggering_event_id).first
      entries.each do |entry|
        entry.matching_entry          = matching_entry
        matching_entry.matching_entry = entry
        entry.save!
        matching_entry.save!
      end
    end

  end

end