class AddRefIdToEvent < ActiveRecord::Migration
  def change
    add_column :events, :reference_id, :integer
  end
end
