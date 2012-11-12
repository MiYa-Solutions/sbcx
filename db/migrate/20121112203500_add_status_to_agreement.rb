class AddStatusToAgreement < ActiveRecord::Migration
  def change
    add_column :agreements, :status, :integer
  end
end
