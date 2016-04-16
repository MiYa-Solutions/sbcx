class AddIndexesToMaterials < ActiveRecord::Migration
  def change
    add_index :materials, :organization_id
    add_index :materials, :supplier_id
  end
end
