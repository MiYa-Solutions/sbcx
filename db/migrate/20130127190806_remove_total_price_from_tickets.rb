class RemoveTotalPriceFromTickets < ActiveRecord::Migration
  def up
    remove_column :tickets, :total_price
  end

  def down
    add_column :tickets, :total_price, :decimal
  end
end
