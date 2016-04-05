class AddTaxToTicket < ActiveRecord::Migration
  def change
    add_column :tickets, :tax, :float
  end
end
