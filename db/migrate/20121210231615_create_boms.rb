class CreateBoms < ActiveRecord::Migration
  def change
    create_table :boms do |t|
      t.integer :ticket_id
      t.decimal :total_price
      t.decimal :total_cost

      t.timestamps
    end
  end
end
