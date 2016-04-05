class AddExternalRefToServiceCalls < ActiveRecord::Migration
  def change
    add_column :tickets, :external_ref, :string
  end
end
