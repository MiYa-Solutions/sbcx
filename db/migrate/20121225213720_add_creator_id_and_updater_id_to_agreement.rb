class AddCreatorIdAndUpdaterIdToAgreement < ActiveRecord::Migration
  def change
    add_column :agreements, :creator_id, :integer
    add_column :agreements, :updater_id, :integer
  end
end
