class AccountingEntrySerializer < ActiveModel::Serializer
  attributes :id, :ticket_id,
             :status,
             :event_id,
             :amount_cents,
             :amount_currency,
             :ticket_id,
             :account_id,
             :created_at,
             :updated_at,
             :type,
             :description,
             :balance_cents,
             :balance_currency,
             :agreement_id,
             :external_ref,
             :collector_id,
             :collector_type,
             :events,
             :matching_entry_id,
             :notes,
             :collector

  def events
    object.allowed_status_events
  end

  def collector
    object.method_exists?(:collector) ? object.collector.try(:name) : ''
  end
end
