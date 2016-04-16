class BillingService

  private
  # this method assumes that @accouting_entries is an array with
  def persist_accounting_entries
    AccountingEntry.transaction do
      @accounting_entries.each do |account, entries|
        account.lock!
        entries.each do |entry|
          unless entry.amount == 0
            account.entries << entry
            if entry.matching_entry
              entry.matching_entry.matching_entry = entry
              entry.matching_entry.save!
            end
            Rails.logger.debug { "Added entry to account: valid? #{entry.valid?}\n#{entry.inspect}" }
          end
        end

      end
    end
  end
end