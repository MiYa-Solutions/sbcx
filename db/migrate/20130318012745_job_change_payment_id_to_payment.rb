class JobChangePaymentIdToPayment < ActiveRecord::Migration
  def up
    remove_column :tickets, :payment_id
    add_column :tickets, :payment_type, :string
  end

  def down
    remove_column :tickets, :payment_type
    add_column :tickets, :payment_id, :integer

  end
end
