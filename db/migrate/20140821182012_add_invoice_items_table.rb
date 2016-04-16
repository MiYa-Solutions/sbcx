class AddInvoiceItemsTable < ActiveRecord::Migration
  def change
    create_table :invoice_items do |t|
      t.integer :invoice_id
      t.integer :invoiceable_id
      t.string :invoiceable_type
    end
    add_index :invoice_items, :invoice_id
  end
end
