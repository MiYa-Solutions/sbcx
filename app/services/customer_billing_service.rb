class CustomerBillingService
  def initialize(event)
    @event   = event
    @ticket  = event.eventable
    @account = Account.where("accountable_id = ? AND accountable_type = 'Customer'", @ticket.customer_id).first
  end

  def execute
    agreement = find_agreement
    Rails.logger.debug { "CustomerBillingService execution for agreement: #{agreement.inspect}" }
    posting_rules = agreement.find_posting_rules(@event)
    Rails.logger.debug { "CustomerBillingService execution for posting rules: #{posting_rules.inspect}" }

    @accounting_entries = get_accounting_entries(posting_rules)

    AccountingEntry.transaction do
      @account.lock!
      @accounting_entries.each do |entry|
        @account.entries << entry
      end
    end
  end

  def get_accounting_entries(posting_rules)
    entries = []
    posting_rules.each do |rule|
      entries.concat rule.get_entries(@event) if rule.applicable?(@event)
    end
    entries
  end

  def find_agreement
    Agreement.where("counterparty_id = ? AND counterparty_type = 'Customer'", @ticket.customer_id).first
  end


end