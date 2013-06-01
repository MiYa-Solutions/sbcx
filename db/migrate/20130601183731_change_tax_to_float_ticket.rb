class ChangeTaxToFloatTicket < ActiveRecord::Migration
  def change
    change_column :tickets, :tax, :float, default: 0.0
  end
end
