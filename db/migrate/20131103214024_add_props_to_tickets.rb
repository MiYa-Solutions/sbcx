class AddPropsToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :properties, :hstore
  end
end
