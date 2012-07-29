class AddServiceCallStatus < ActiveRecord::Migration
  def up
    add_column :service_calls, :status, :integer

  end

  def down
    remove_column :service_calls, :status
  end
end
