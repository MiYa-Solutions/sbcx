class IndexTicketProperties < ActiveRecord::Migration
  def up
    execute "CREATE INDEX tickets_properties ON tickets USING GIN(properties)"
  end

  def down
    execute "DROP INDEX tickets_properties"
  end
end
