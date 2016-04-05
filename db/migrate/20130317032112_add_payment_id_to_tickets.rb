class AddPaymentIdToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :payment_id, :integer
  end
end
