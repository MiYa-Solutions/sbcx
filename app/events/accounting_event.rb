class AccountingEvent < Event
  delegate :customer, :provider, :subcontractor, :total_cost, :total_price, :total_profit, :provider_cost, :subcontractor_cost, :technician_cost, to: :eventable

  def init
    self.name         = "Accounting Event"
    self.description  = "Accounting Event Description TEST"
    self.reference_id = 51
  end

  ##
  # this is the standard event method which gets invoked by the EventObserver after the creation
  def process_event

    Rails.logger.debug { "Running #{self.class.name} process_event method" }
    unless subcontractor.nil?
      agreement = find_agreement

      posting_rules = agreement.find_posting_rules(self)

      accounting_entries = []

      posting_rules.each do |rule|
        accounting_entries = accounting_entries + posting_rules.process(self)
      end

      agreement.transaction do
        begin
          accounting_entries.each do |entry|
            entry.save
          end
        rescue ActiveRecord::StatementInvalid => e

          Rails.logger.error { "Error during the save of account entries: #{e.inspect}" }

        end


      end
    end


  end


  def ticket
    eventable
  end

  def find_agreement
    Agreement.where(organization_id: provider.id, counterparty_id: subcontractor.id).first
  end
end
