class AddMatchingEntryIdToAccountingEntries < ActiveRecord::Migration
  def change
    add_column :accounting_entries, :matching_entry_id, :integer
  end
end
