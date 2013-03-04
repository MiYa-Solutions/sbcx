class ChangePaymentTermsToStringAgreement < ActiveRecord::Migration
  def up
    change_column :agreements, :payment_terms, :string
  end

end
