class AddOrgIndexOnCustomers < ActiveRecord::Migration
  def change
    add_index :customers, :organization_id
  end
end
