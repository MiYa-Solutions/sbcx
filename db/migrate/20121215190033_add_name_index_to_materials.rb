class AddNameIndexToMaterials < ActiveRecord::Migration
  def change
    add_index :materials, :name
  end
end
