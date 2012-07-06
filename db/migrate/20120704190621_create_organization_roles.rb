class CreateOrganizationRoles < ActiveRecord::Migration
  def change
    create_table :organization_roles, id: false do |t|
      t.integer :id, :null =>false
      t.primary_key :id

      t.string :name
      t.timestamps
    end
  end
end
