class AddTaxDefaultTicket < ActiveRecord::Migration
  def change
    change_column :tickets, :tax, :decimal, default: 0.0
  end
end
