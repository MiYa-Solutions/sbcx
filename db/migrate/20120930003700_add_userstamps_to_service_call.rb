class AddUserstampsToServiceCall < ActiveRecord::Migration
  def change
    add_column :service_calls, :creator_id, :integer
    add_column :service_calls, :updater_id, :integer
  end
end
