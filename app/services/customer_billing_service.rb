class CustomerBillingService < BillingService
  def initialize(event)
    @event   = event
    @ticket  = event.eventable
    @accounting_entries = {}
    @entries_to_cancel = {}
    @account = Account.where("accountable_id = ? AND accountable_type = 'Customer'", @ticket.customer_id).first
  end

  def execute
    collect_accounting_entries
    persist_accounting_entries
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

  private

  def collect_accounting_entries
    agreement = find_agreement
    Rails.logger.debug { "CustomerBillingService execution for agreement: #{agreement.inspect}" }
    posting_rules = agreement.find_posting_rules(@event)
    Rails.logger.debug { "CustomerBillingService execution for posting rules: #{posting_rules.inspect}" }

    @accounting_entries[@account] = get_accounting_entries(posting_rules)
  end

  def persist_accounting_entries
    AccountingEntry.transaction do
      @accounting_entries.each do |account, entries|
        account.lock!
        entries.each do |entry|
          account.entries << entry
          Rails.logger.debug { "Added entry to account: valid? #{entry.valid?}\n#{entry.inspect}" }
        end

      end
      @entries_to_cancel.each do

    end
    end

  end
end