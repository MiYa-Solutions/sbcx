class AddAccountIdToStatements < ActiveRecord::Migration
  def change
    add_column :statements, :account_id, :integer
    remove_column :statements, :statementable_id
    remove_column :statements, :statementable_type
  end
end
