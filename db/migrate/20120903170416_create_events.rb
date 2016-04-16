class CreateEvents < ActiveRecord::Migration
  def change
    create_table :events do |t|
      t.string :name
      t.string :type
      t.string :description
      t.string :eventable_type
      t.integer :eventable_id

      t.timestamps
    end
    add_index :events, [:eventable_id, :eventable_type]
  end
end
