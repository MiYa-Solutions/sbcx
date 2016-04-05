class AddMaterialToBoms < ActiveRecord::Migration
  def change
    add_column :boms, :material_id, :integer
    add_index :boms, :material_id
  end
end
