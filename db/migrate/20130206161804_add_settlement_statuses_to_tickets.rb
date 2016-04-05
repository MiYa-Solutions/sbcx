class AddSettlementStatusesToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :provider_status, :integer
    add_column :tickets, :work_status, :integer
  end
end
