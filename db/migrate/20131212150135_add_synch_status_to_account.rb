class AddSynchStatusToAccount < ActiveRecord::Migration
  def change
    add_column :accounts, :synch_status, :integer
  end
end
