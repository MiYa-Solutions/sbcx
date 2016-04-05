class AddEmployeeToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :employee_id, :integer
  end
end
