class AddNotesToAccountingEntry < ActiveRecord::Migration
  def change
    add_column :accounting_entries, :notes, :string
  end
end
