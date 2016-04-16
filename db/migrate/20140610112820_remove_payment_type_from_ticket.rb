class RemovePaymentTypeFromTicket < ActiveRecord::Migration
  def change
    remove_column :tickets, :payment_type
  end
end
