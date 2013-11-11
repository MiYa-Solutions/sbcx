class AffiliatePostingRule < PostingRule

  def get_transfer_props
    self::TransferProperties.new
  end

  class TransferProperties < TicketProperties
  end


  # To change this template use File | Settings | File Templates.
  # todo implement timebound check
  def applicable?(event)
    case event.class.name
      when ServiceCallCompletedEvent.name
        true
      when ServiceCallCompleteEvent.name
        event.eventable.instance_of?(MyServiceCall) && event.eventable.transferred? ||
            event.eventable.instance_of?(TransferredServiceCall)
      when ScSubconSettleEvent.name
        true
      when ScProviderSettleEvent.name
        true
      when ScSubconSettledEvent.name
        true
      when ScProviderSettledEvent.name
        true
      when ServiceCallCancelEvent.name
        true
      when ServiceCallCanceledEvent.name
        true
      when ScCollectEvent.name
        true
      when ServiceCallPaidEvent.name
        true
      when ScCollectedEvent.name
        true
      when ScProviderCollectedEvent.name
        true
      else
        false
    end
  end


  def charge_entries
    case @account.accountable
      when @ticket.subcontractor.becomes(Organization)
        organization_entries
      when @ticket.provider.becomes(Organization)
        counterparty_entries
      else
        raise "The account beneficiary (name: '#{@account.accountable.name}', type: #{@account.accountable_type}) is neither the provider or subcontractor"
    end
  end

  def collection_entries
    case @account.accountable
      when @ticket.subcontractor.becomes(Organization)
        org_collection_entries
      when @ticket.provider.becomes(Organization)
        cparty_collection_entries
      else
        raise "The account beneficiary (name: '#{@account.accountable.name}', type: #{@account.accountable_type}) is neither the provider or subcontractor"
    end
  end

  def payment_entries
    case @account.accountable
      when @ticket.subcontractor.becomes(Organization)
        org_payment_entries
      when @ticket.provider.becomes(Organization)
        cparty_payment_entries
      else
        raise "The account beneficiary (name: '#{@account.accountable.name}', type: #{@account.accountable_type}) is neither the provider or subcontractor"
    end
  end

  def settlement_entries
    case @account.accountable
      when @ticket.subcontractor.becomes(Organization)
        org_settlement_entries
      when @ticket.provider.becomes(Organization)
        counterparty_settlement_entries
      else
        raise "The account beneficiary (name: '#{@account.accountable.name}', type: #{@account.accountable_type}) is neither the provider or subcontractor"
    end

  end
end

Dir["#{Rails.root}/app/models/posting_rules/affiliate/*.rb"].each do |file|
  require_dependency file
end
