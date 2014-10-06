class AddInvoicesTable < ActiveRecord::Migration
  def change
    create_table :invoices do |t|
      t.integer :account_id
      t.integer :ticket_id
      t.integer :organization_id

      t.timestamps
      t.userstamps
    end
    add_index :invoices, :ticket_id
  end
end
