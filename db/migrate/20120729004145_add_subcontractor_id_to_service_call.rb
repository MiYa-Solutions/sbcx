class AddSubcontractorIdToServiceCall < ActiveRecord::Migration
  def change
    add_column :service_calls, :subcontractor_id, :integer

  end
end
