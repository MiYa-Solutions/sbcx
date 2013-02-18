class IndexUsersPreferences < ActiveRecord::Migration
  def up
    execute "CREATE INDEX users_preferences ON users USING GIN(preferences)"
  end

  def down
    execute "DROP INDEX users_preferences"
  end
end
