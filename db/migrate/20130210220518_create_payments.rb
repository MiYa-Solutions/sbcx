class CreatePayments < ActiveRecord::Migration
  def change
    create_table :payments do |t|
      t.integer :agreement_id
      t.string :type
      t.float :rate
      t.string :rate_type

      t.timestamps
    end
  end
end
