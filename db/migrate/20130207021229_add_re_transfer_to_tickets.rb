class AddReTransferToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :re_transfer, :boolean
  end
end
