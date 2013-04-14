class AddAddressToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :company, :string
    add_column :tickets, :address1, :string
    add_column :tickets, :address2, :string
    add_column :tickets, :city, :string
    add_column :tickets, :state, :string
    add_column :tickets, :zip, :string
    add_column :tickets, :country, :string
    add_column :tickets, :phone, :string
    add_column :tickets, :mobile_phone, :string
    add_column :tickets, :work_phone, :string
    add_column :tickets, :email, :string
  end
end
