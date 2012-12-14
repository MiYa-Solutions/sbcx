class RenameBomsTotalsToSingleUnit < ActiveRecord::Migration
  def change
    rename_column :boms, :total_price, :price
    rename_column :boms, :total_cost, :cost
    add_column :boms, :quantity, :decimal
  end
end
