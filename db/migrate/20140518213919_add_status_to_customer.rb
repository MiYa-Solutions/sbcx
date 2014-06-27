class AddStatusToCustomer < ActiveRecord::Migration
  def change
    add_column :customers, :status, :integer
    Customer.all.each do |cus|
      cus.status = Customer::STATUS_ACTIVE
      cus.save!
    end
  end
end
