class AddIndexToTags < ActiveRecord::Migration
  def change
    add_index :tags, :organization_id
  end
end
