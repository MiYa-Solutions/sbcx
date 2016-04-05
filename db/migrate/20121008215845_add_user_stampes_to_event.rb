class AddUserStampesToEvent < ActiveRecord::Migration
  def change
    add_column :events, :creator_id, :integer
    add_column :events, :updater_id, :integer
  end
end
