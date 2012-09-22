class AddColumnToServiceCalls < ActiveRecord::Migration
  def change
    add_column :service_calls, :technician_id, :integer
  end
end
