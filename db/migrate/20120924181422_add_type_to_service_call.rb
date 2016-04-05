class AddTypeToServiceCall < ActiveRecord::Migration
  def change
    add_column :service_calls, :type, :string
  end
end
