class AddPreferencesToOrgAndCus < ActiveRecord::Migration

  def up
    add_column :organizations, :properties, :hstore
    add_column :customers, :properties, :hstore
    execute "CREATE INDEX org_preferences ON organizations USING GIN(properties)"
    execute "CREATE INDEX customer_properties ON customers USING GIN(properties)"
  end

  def down
    remove_column :organizations, :properties
    execute "DROP INDEX org_preferences"
    remove_column :customers, :properties
    execute "DROP INDEX customer_properties"
  end
end
