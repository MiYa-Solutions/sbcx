class MonitizeBom < ActiveRecord::Migration
  def change
    remove_column :boms, :cost
    remove_column :boms, :price
    add_money :boms, :cost
    add_money :boms, :price
  end

end
