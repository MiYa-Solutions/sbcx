class AddProviderColumnToServiceCalls < ActiveRecord::Migration
  def change
    add_column :service_calls, :provider_id, :integer
  end
end
