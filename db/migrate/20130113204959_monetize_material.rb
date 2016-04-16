class MonetizeMaterial < ActiveRecord::Migration
  def change
    remove_column :materials, :cost
    remove_column :materials, :price
    add_money :materials, :cost
    add_money :materials, :price
  end

end
