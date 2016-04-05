class AddExternalRefIndexToTickets < ActiveRecord::Migration
  def change
    add_index :tickets, [:organization_id, :external_ref]
  end
end
