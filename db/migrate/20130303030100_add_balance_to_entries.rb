class AddBalanceToEntries < ActiveRecord::Migration
  def change
    add_money :accounting_entries, :balance
  end
end
