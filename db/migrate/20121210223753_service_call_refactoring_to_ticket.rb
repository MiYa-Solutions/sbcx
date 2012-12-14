class ServiceCallRefactoringToTicket < ActiveRecord::Migration
  def change
    rename_table :service_calls, :tickets
  end
end
