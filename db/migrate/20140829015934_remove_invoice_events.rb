class RemoveInvoiceEvents < ActiveRecord::Migration
  def up
    Event.where(type: 'ServiceCallInvoiceEvent').delete_all
  end

  def down
  end
end
