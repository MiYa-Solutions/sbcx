class AddTotalPriceToServiceCall < ActiveRecord::Migration
  def change
    add_column :service_calls, :total_price, :decimal
  end
end
