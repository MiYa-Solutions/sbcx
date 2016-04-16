class AddBalanceToAccount < ActiveRecord::Migration
  def change
    add_money :accounts, :balance
  end
end
