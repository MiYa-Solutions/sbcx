class AddRefIdToServiceCall < ActiveRecord::Migration
  def change
    add_column :service_calls, :ref_id, :integer
    add_index :service_calls, :ref_id
  end
end
