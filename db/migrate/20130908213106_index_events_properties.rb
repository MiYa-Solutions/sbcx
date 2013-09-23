class IndexEventsProperties < ActiveRecord::Migration
  def up
    execute "CREATE INDEX events_properties ON events USING GIN(properties)"
  end

  def down
    execute "DROP INDEX products_properties"
  end
end
