class AddAssociationsToProject < ActiveRecord::Migration
  def change
    add_column :projects, :customer_id, :integer
    add_column :projects, :contractor_id, :integer
    add_column :projects, :subcontractor_id, :integer
  end
end
