class AddAgreementToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :agreement_id, :integer
  end
end
