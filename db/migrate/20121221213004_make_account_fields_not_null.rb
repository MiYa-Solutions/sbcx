class MakeAccountFieldsNotNull < ActiveRecord::Migration
  def up
    change_column :accounts, :organization_id, :integer, null: false
    change_column :accounts, :accountable_id, :integer, null: false
    change_column :accounts, :accountable_type, :string, null: false
  end

  def down
    change_column :accounts, :organization_id, :integer
    change_column :accounts, :accountable_id, :integer
    change_column :accounts, :accountable_type, :string

  end
end
