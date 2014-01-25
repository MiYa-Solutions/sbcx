class AddReferenceToAccountingEntries < ActiveRecord::Migration
  def change
    add_column :accounting_entries, :external_ref, :string
  end
end
