class AddDeletedAtToMaterial < ActiveRecord::Migration
  def change
    add_column :materials, :deleted_at, :datetime
  end
end
