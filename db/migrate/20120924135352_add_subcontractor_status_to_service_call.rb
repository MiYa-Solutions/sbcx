class AddSubcontractorStatusToServiceCall < ActiveRecord::Migration
  def change
    add_column :service_calls, :subcontractor_status, :integer
  end
end
