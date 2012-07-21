class CreateOrganizationRoles < ActiveRecord::Migration
  def change
    create_table :organization_roles, id: false, :primary_key => :id do |t|
      t.integer :id, :null => false
      t.string :name
      t.timestamps
    end
  end
end
