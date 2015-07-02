# == Schema Information
#
# Table name: accounts
#
#  id               :integer          not null, primary key
#  organization_id  :integer          not null
#  accountable_id   :integer          not null
#  accountable_type :string(255)      not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  balance_cents    :integer          default(0), not null
#  balance_currency :string(255)      default("USD"), not null
#  synch_status     :integer
#

class Account < ActiveRecord::Base
  include Statementable

  before_create :set_initial_synch_status

  monetize :balance_cents

  belongs_to :organization
  belongs_to :accountable, :polymorphic => true

  has_many :accounting_entries do
    def << (entry)
      entry.amount = (entry.amount_direction < 0 && entry.amount > 0) ? entry.amount * entry.amount_direction : entry.amount
      proxy_association.owner.balance += entry.amount
      entry.account                   = proxy_association.owner
      entry.balance                   = proxy_association.owner.balance
      entry.save
    end
  end
  has_many :events, as: :eventable

  alias_method :entries, :accounting_entries

  scope :for, ->(org, accountable) { where("organization_id = ? AND accountable_id = ? AND accountable_type = ?", org.id, accountable.id, accountable.class.name) }
  scope :for_affiliate, ->(org, affiliate) { where("organization_id = ? AND accountable_id = ? AND accountable_type = 'Organization'", org.id, affiliate.id) }
  scope :for_affiliates, ->(org) { where("organization_id = ? AND accountable_type = 'Organization'", org.id) }
  scope :for_customers, ->(org) { where("organization_id = ? AND accountable_type = 'Customer'", org.id) }
  scope :for_affiliates_with_balance, ->(org) { for_affiliates(org).where('balance_cents <> 0') }
  scope :for_customers_with_balance, ->(org) { for_customers(org).where('balance_cents <> 0') }
  scope :for_customer, ->(customer) { where("accountable_id = ? AND accountable_type = 'Customer'", customer.id) }

  ##
  # state machine
  ##

  SYNCH_STATUS_NA            = 0
  SYNCH_STATUS_IN_SYNCH      = 1
  SYNCH_STATUS_OUT_OF_SYNCH  = 2
  SYNCH_STATUS_ADJ_SUBMITTED = 3

  state_machine :synch_status do
    state :synch_na, value: SYNCH_STATUS_NA
    state :in_synch, value: SYNCH_STATUS_IN_SYNCH
    state :out_of_synch, value: SYNCH_STATUS_OUT_OF_SYNCH
    state :adjustment_submitted, value: SYNCH_STATUS_ADJ_SUBMITTED

    event :synch do
      transition any - [:synch_na] => :in_synch
    end

    event :un_synch do
      transition any - [:synch_na] => :out_of_synch
    end

    event :adj_submitted do
      transition any - [:synch_na] => :adjustment_submitted
    end

  end

  def adj_entries
    AdjustmentEntry.find_all_by_account_id(self.id)
  end

  def open_adj_entries
    entries.where(type: [MyAdjEntry, ReceivedAdjEntry]).
        where(status: [AdjustmentEntry::STATUS_SUBMITTED, AdjustmentEntry::STATUS_REJECTED ]).all
  end

  # make state machine event methods private as they should only be invoked from the following methods
  private :synch, :un_synch, :adj_submitted

  def adjustment_submitted
    self.adj_submitted! unless self.out_of_synch?
  end

  def adjustment_accepted
    if rejected_adj_entries.size > 0
      self.un_synch!
    elsif submitted_adj_entries.size > 0
      self.adj_submitted!
    else
      self.synch!
    end
  end

  def adjustment_rejected
    self.un_synch!
  end

  def adjustment_canceled(entry)
    self.balance = self.balance - entry.amount if entry.instance_of?(MyAdjEntry)
    self.adjustment_accepted
  end

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


  def rejected_adj_entries
    adj_entries_by_type(:rejected)
  end

  def submitted_adj_entries
    adj_entries_by_type(:submitted, :pending)
  end

  def payments
    AccountingEntry.where(account_id: self.id).where(type: AccountingEntry.payment_entry_classes)
  end

  private

  def adj_entries_by_type(*type_symbols)
    AdjustmentEntry.where(account_id: self.id).with_statuses(type_symbols)
  end

  def set_initial_synch_status
    if accountable.kind_of?(Organization) && accountable.member?
      self.synch_status = SYNCH_STATUS_IN_SYNCH
    else
      self.synch_status = SYNCH_STATUS_NA
    end

  end


end
