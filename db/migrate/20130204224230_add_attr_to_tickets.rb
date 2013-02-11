class AddAttrToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :transferable, :boolean, :default => false
    add_column :tickets, :allow_collection, :boolean, :default => true
  end
end
