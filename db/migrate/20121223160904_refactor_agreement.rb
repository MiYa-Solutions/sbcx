class RefactorAgreement < ActiveRecord::Migration
  def change
    rename_column :agreements, :provider_id, :organization_id
    rename_column :agreements, :subcontractor_id, :counterparty_id
    add_column :agreements, :counterparty_type, :string
    add_column :agreements, :type, :string

  end
end
