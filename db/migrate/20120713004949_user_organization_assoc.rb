class UserOrganizationAssoc < ActiveRecord::Migration
  def up
    add_column :users, :organization_id, :integer
  end

  def down
    remove_column :users, :organization_id
  end
end
