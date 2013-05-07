class AddUserstampsToBoms < ActiveRecord::Migration
  def change
    add_column :boms, :creator_id, :integer
    add_column :boms, :updater_id, :integer
  end
end
