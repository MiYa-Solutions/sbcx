class AddBillingStatusToServiceCalls < ActiveRecord::Migration
  def change
    add_column :service_calls, :billing_status, :integer
  end
end
