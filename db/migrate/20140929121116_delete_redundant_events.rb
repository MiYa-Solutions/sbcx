class DeleteRedundantEvents < ActiveRecord::Migration
  def up
    execute "DELETE FROM events where events.type IN ('EntryCancelEvent', 'EntryCanceledEvent', 'ScProviderInvoicedEvent', 'ServiceCallInvoiceEvent', 'ServiceCallInvoicedEvent', 'ServiceCallUnCancelEvent')"
  end

  def down
  end
end
