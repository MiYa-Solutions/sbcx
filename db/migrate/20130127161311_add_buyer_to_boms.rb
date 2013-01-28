class AddBuyerToBoms < ActiveRecord::Migration
  def change
    add_column :boms, :buyer_id, :integer
    add_column :boms, :buyer_type, :string
  end
end
