class RemoveSubcontractorIdFromProjects < ActiveRecord::Migration
  def change
    remove_column :projects, :subcontractor_id
    add_column :projects, :provider_agreement_id, :integer
    rename_column :projects, :contractor_id, :provider_id
  end

end
