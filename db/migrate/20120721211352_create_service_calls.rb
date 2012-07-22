class CreateServiceCalls < ActiveRecord::Migration
  def change
    create_table :service_calls do |t|
      t.integer :customer_id
      t.text :notes
      t.datetime :started_on
      t.integer :organization_id
      t.datetime :completed_on

      t.timestamps
    end
  end
end
