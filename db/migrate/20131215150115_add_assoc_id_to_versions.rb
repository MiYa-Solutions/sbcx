class AddAssocIdToVersions < ActiveRecord::Migration
  def change
    add_column :versions, :assoc_id, :integer
  end
end
