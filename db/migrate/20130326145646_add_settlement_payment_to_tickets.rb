class AddSettlementPaymentToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :subcon_payment, :string
    add_column :tickets, :provider_payment, :string
  end
end
