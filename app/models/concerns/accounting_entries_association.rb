module AccountingEntriesAssociation
  extend ActiveSupport::Concern
  included do
    before_destroy :reverse_account_balance, prepend: true

    has_many :accounting_entries, dependent: :destroy
    alias_method :entries, :accounting_entries

  end

  def subcon_entries
    if subcontractor
      acc = Account.for_affiliate(organization, subcontractor).first
      acc ? entries.by_acc(acc) : AccountingEntry.none
    else
      AccountingEntry.none
    end
  end

  def active_subcon_entries
    if subcontractor.member?
      subcon_entries.where('status NOT in (?)', non_active_member_statuses)
    else
      subcon_entries.where('status NOT in (?)', non_active_local_statuses)
    end

  end

  def non_active_member_statuses
    [AccountingEntry::STATUS_CLEARED, AdjustmentEntry::STATUS_CANCELED, AdjustmentEntry::STATUS_ACCEPTED]
  end

  def non_active_member_provider_statuses
    [AccountingEntry::STATUS_CLEARED, AdjustmentEntry::STATUS_CANCELED, AdjustmentEntry::STATUS_ACCEPTED]
  end

  def non_active_local_statuses
    [AccountingEntry::STATUS_CLEARED, AdjustmentEntry::STATUS_CANCELED, AdjustmentEntry::STATUS_REJECTED]
  end


  def provider_entries
    if provider
      acc = Account.for_affiliate(organization, provider).first
      acc ? entries.by_acc(acc) : AccountingEntry.none
    else
      AccountingEntry.none
    end
  end

  def active_provider_entries
    if subcontractor.member?
      provider_entries.where('status NOT in (?)', non_active_member_provider_statuses)
    else
      subcon_entries.where('status NOT in (?)', non_active_local_statuses)
    end


  end

  def customer_entries
    if customer
      acc = Account.for_customer(customer).first
      acc ? entries.by_acc(acc) : AccountingEntry.none
    else
      AccountingEntry.none
    end
  end

  def active_customer_entries
    customer_entries.where('status NOT in (?)', [AccountingEntry::STATUS_CLEARED, CustomerPayment::STATUS_REJECTED, AdjustmentEntry::STATUS_CANCELED, AdjustmentEntry::STATUS_ACCEPTED])
  end

  private

  def reverse_account_balance
    entries.group(:account_id).sum(:amount_cents).each do |the_id, the_amount|
      acc = Account.find(the_id)
      acc.update_attributes(balance_cents: (acc.balance_cents - the_amount))
    end

  end

end