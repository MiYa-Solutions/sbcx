class AddNameToServiceCall < ActiveRecord::Migration
  def change
    add_column :service_calls, :name, :string
  end
end
