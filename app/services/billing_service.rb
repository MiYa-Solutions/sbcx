class BillingService
  def initialize(event)
    @event  = event
    @ticket = event.eventable
  end

  def execute
    agreement = find_affiliate_agreement
    Rails.logger.debug { "BillingService execution for agreement: #{agreement.inspect}" }
    posting_rules = agreement.find_posting_rules(@event)
    Rails.logger.debug { "BillingService execution for posting rules: #{posting_rules.inspect}" }

    @accounting_entries = get_accounting_entries(posting_rules)

    AccountingEntry.transaction(:requires_new => true) do
      @accounting_entries.each do |entry|
        entry.save!
      end
    end
  end

  def find_affiliate_agreement
    OrganizationAgreement.where("status = #{OrganizationAgreement::STATUS_ACTIVE} AND organization_id = ? AND counterparty_id = ?", @ticket.provider_id, @ticket.subcontractor_id).first
  end

  def accounting_entries
    @accounting_entries
  end

  def get_accounting_entries(posting_rules)
    entries = []
    posting_rules.each do |rule|
      entries.concat rule.get_entries(@event)
    end
    entries
  end


end