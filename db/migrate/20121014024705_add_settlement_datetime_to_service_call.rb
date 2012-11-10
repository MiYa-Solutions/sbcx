class AddSettlementDatetimeToServiceCall < ActiveRecord::Migration
  def change
    add_column :service_calls, :settlement_date, :datetime
  end
end
