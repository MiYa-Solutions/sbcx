class AddParentOrgIdToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :parent_org_id, :integer
  end
end
