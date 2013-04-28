class ChangeAgreementAttrTickets < ActiveRecord::Migration
  def change
    rename_column :tickets, :agreement_id, :subcon_agreement_id
    add_column :tickets, :provider_agreement_id, :integer
  end

end
