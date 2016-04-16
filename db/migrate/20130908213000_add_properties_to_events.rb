class AddPropertiesToEvents < ActiveRecord::Migration
  def change
    add_column :events, :properties, :hstore
  end
end
