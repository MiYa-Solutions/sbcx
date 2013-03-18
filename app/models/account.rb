# == Schema Information
#
# Table name: accounts
#
#  id               :integer         not null, primary key
#  organization_id  :integer         not null
#  accountable_id   :integer         not null
#  accountable_type :string(255)     not null
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#  balance_cents    :integer         default(0), not null
#  balance_currency :string(255)     default("USD"), not null
#

class Account < ActiveRecord::Base

  monetize :balance_cents

  belongs_to :organization
  belongs_to :accountable, :polymorphic => true

  has_many :accounting_entries do
    def << (entry)
      proxy_association.owner.balance += (entry.amount * entry.amount_direction)
      entry.account                   = proxy_association.owner
      entry.balance                   = proxy_association.owner.balance
      entry.save!
    end
  end

  alias_method :entries, :accounting_entries

  scope :for_affiliate, ->(org, affiliate) { where("organization_id = ? AND accountable_id = ? AND accountable_type = 'Organization'", org.id, affiliate.id) }
  scope :for_customer, ->(org, customer) { where("organization_id = ? AND accountable_id = ? AND accountable_type = 'Customer'", org.id, customer.id) }
  scope :for, ->(org, accountable) { where("organization_id = ? AND accountable_id = ? AND accountable_type = ?", org.id, accountable.id, accountable.class.name) }

  def current_balance
    balance_for Time.now.utc
  end

  def balance_for(datetime)
    get_balance self.created_at.utc..datetime
  end


  def get_balance(date_range)
    result = Money.new_with_amount(0)
    AccountingEntry.by_account_and_datetime_range(self, date_range).each do |entry|
      result += entry.amount
    end
    result
  end


end
