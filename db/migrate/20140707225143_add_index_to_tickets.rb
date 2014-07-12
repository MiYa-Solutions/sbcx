class AddIndexToTickets < ActiveRecord::Migration
  def change
    add_index :tickets, :organization_id
  end
end
