class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.integer :organization_id
      t.integer :accountable_id
      t.string :accountable_type

      t.timestamps
    end

    add_index :accounts, :organization_id
    add_index :accounts, [:accountable_id, :accountable_type]
  end
end
