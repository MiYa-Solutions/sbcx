class AddColumnToInvoices < ActiveRecord::Migration
  def change
    add_column :invoices, :notes, :text
    add_column :invoices, :total_cents, :integer
    add_column :invoices, :total_currency, :string
  end
end
