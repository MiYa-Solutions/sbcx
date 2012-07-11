class AddOrgRolePrimaryKey < ActiveRecord::Migration
  def up
    execute "ALTER TABLE ORGANIZATION_ROLES ADD PRIMARY KEY (id);"
  end

  def down
  end
end
