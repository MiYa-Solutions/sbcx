class CreateOrgToRoles < ActiveRecord::Migration
  def change
    create_table :org_to_roles do |t|
      t.integer :organization_id
      t.integer :organization_role_id
      t.timestamps
    end
    add_index :org_to_roles, [:organization_id, :organization_role_id]
  end
end
