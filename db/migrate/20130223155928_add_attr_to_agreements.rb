class AddAttrToAgreements < ActiveRecord::Migration
  def change
    add_column :agreements, :starts_at, :datetime
    add_column :agreements, :ends_at, :datetime
    add_column :agreements, :payment_terms, :integer
  end
end
