class AddDescriptionToBoms < ActiveRecord::Migration
  def change
    add_column :boms, :description, :string
  end
end
