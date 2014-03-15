class AddCollectorToAccountingEntries < ActiveRecord::Migration
  def change
    add_column :accounting_entries, :collector_id, :integer
    add_column :accounting_entries, :collector_type, :string
  end
end
