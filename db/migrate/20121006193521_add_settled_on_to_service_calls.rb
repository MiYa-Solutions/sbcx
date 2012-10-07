class AddSettledOnToServiceCalls < ActiveRecord::Migration
  def change
    add_column :service_calls, :settled_on, :datetime
  end
end
