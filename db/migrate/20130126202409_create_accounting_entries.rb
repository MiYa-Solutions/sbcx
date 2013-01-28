class CreateAccountingEntries < ActiveRecord::Migration
  def change
    create_table :accounting_entries do |t|
      t.integer :status
      t.integer :event_id
      t.money :amount
      t.integer :ticket_id
      t.integer :account_id

      t.timestamps
    end
  end
end
