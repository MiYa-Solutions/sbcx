class CreateAgreements < ActiveRecord::Migration
  def change
    create_table :agreements do |t|
      t.string :name
      t.integer :subcontractor_id
      t.integer :provider_id
      t.text :description

      t.timestamps
    end
  end
end
