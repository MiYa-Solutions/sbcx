class AddTypeToAccounts < ActiveRecord::Migration
  def up
    add_column :accounts, :type, :string

    Account.all.each do |a|
      if a.accountable.kind_of?(Organization)
        a.type = 'AffiliateAccount'
      else
        a.type = 'CustomerAccount'
      end
      a.save!
    end

  end

  def down
    remove_column :accounts, :type
  end
end
