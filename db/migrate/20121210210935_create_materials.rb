class CreateMaterials < ActiveRecord::Migration
  def change
    create_table :materials do |t|
      t.integer :organization_id
      t.integer :supplier_id
      t.string :name
      t.text :description
      t.decimal :cost
      t.decimal :price
      t.integer :creator_id
      t.integer :updater_id
      t.integer :status

      t.timestamps
    end
  end
end
