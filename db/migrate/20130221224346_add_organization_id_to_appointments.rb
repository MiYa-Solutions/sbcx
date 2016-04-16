class AddOrganizationIdToAppointments < ActiveRecord::Migration
  def change
    add_column :appointments, :organization_id, :integer
  end
end
