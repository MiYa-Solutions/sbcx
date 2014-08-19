class AddProvBomSubconBomToBoms < ActiveRecord::Migration
  def change
    add_column :boms, :provider_bom_id, :integer
    add_column :boms, :subcon_bom_id, :integer
  end
end
