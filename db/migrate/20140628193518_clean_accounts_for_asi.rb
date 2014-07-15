class CleanAccountsForAsi < ActiveRecord::Migration
  def up
    Account.all.each do |acc|
      acc.destroy if acc.accountable.nil?
    end
  end

  def down
  end
end
