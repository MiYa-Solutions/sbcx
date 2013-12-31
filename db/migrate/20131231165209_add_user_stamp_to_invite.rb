class AddUserStampToInvite < ActiveRecord::Migration
  def change
    add_column :invites, :creator_id, :integer
    add_column :invites, :updater_id, :integer
  end
end
