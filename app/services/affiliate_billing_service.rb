class AffiliateBillingService < BillingService
  def initialize(event)
    @event              = event
    @ticket             = event.eventable
    @accounting_entries = {}
  end

  def execute
    collect_accounting_entries
    persist_accounting_entries
  end

  def find_affiliate_agreement
    #OrganizationAgreement.where("status = #{OrganizationAgreement::STATUS_ACTIVE} AND organization_id = ? AND counterparty_id = ?", @ticket.provider_id, @ticket.subcontractor_id).first
    case @event.eventable.my_role
      when :prov
        @event.eventable.subcon_agreement
      when :subcon
        @event.eventable.provider_agreement
      when :broker
        if @event.eventable.provider.becomes(Organization) == @account.accountable
          @event.eventable.provider_agreement
        elsif @event.eventable.subcontractor.becomes(Organization) == @account.accountable
          @event.eventable.subcon_agreement
        end
      else
        raise "Unexpected value when calling my_role"
    end
  end

  def accounting_entries
    @accounting_entries
  end

  def get_accounting_entries(posting_rules)
    entries = []
    posting_rules.each do |rule|
      entries.concat rule.get_entries(@event, @account) if rule.applicable?(@event)
    end
    entries
  end

  private

  def collect_accounting_entries
    @ticket.counterparty.each do |affiliate|
      @account = Account.where("organization_id = ? AND accountable_id = ? AND accountable_type = 'Organization'",
                               @ticket.organization_id,
                               affiliate.id,
      ).first


      agreement = find_affiliate_agreement
      Rails.logger.debug { "BillingService execution for agreement: #{agreement.inspect}" }
      posting_rules = agreement.find_posting_rules(@event)
      Rails.logger.debug { "BillingService execution for posting rules: #{posting_rules.inspect}" }

      @accounting_entries[@account] = get_accounting_entries(posting_rules)

    end

  end





end