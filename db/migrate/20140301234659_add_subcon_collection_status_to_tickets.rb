class AddSubconCollectionStatusToTickets < ActiveRecord::Migration
  def change
    add_column :tickets, :subcon_collection_status, :integer
    add_column :tickets, :prov_collection_status, :integer
  end
end
