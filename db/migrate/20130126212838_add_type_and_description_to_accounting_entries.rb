class AddTypeAndDescriptionToAccountingEntries < ActiveRecord::Migration
  def change
    add_column :accounting_entries, :type, :string
    add_column :accounting_entries, :description, :string
  end
end
