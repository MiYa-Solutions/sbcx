class AddAgreementToAccountingEntries < ActiveRecord::Migration
  def change
    add_column :accounting_entries, :agreement_id, :integer
  end
end
