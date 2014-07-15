# == Schema Information
#
# Table name: posting_rules
#
#  id             :integer          not null, primary key
#  agreement_id   :integer
#  type           :string(255)
#  rate           :decimal(, )
#  rate_type      :string(255)
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  properties     :hstore
#  time_bound     :boolean          default(FALSE)
#  sunday         :boolean          default(FALSE)
#  monday         :boolean          default(FALSE)
#  tuesday        :boolean          default(FALSE)
#  wednesday      :boolean          default(FALSE)
#  thursday       :boolean          default(FALSE)
#  friday         :boolean          default(FALSE)
#  saturday       :boolean          default(FALSE)
#  sunday_from    :time
#  monday_from    :time
#  tuesday_from   :time
#  wednesday_from :time
#  thursday_from  :time
#  friday_from    :time
#  saturday_from  :time
#  sunday_to      :time
#  monday_to      :time
#  tuesday_to     :time
#  wednesday_to   :time
#  thursday_to    :time
#  friday_to      :time
#  saturday_to    :time
#

class ProfitSplit < AffiliatePostingRule

  validates_presence_of :rate, :rate_type
  validates_numericality_of :rate

  def rate_types
    [:percentage]
  end


  protected

  def counterparty_cut
    @ticket.total_profit * (rate / 100.0)
  end


  def cash_fee
    fee = super
    fee * (rate / 100.0)
  end

  def credit_fee
    fee = super
    fee * (rate / 100.0)
  end

  def cheque_fee
    fee = super
    fee * (rate / 100.0)
  end

  def amex_fee
    fee = super
    fee * (rate / 100.0)
  end


  def org_charge_entries
    entries = []
    entries << PaymentToSubcontractor.new(agreement: agreement, event: @event, ticket: @ticket, amount: counterparty_cut, status: AccountingEntry::STATUS_CLEARED, description: "Entry to provider owned account")
    @ticket.boms.each do |bom|
      if bom.buyer == agreement.counterparty
        entries << MaterialReimbursementToCparty.new(agreement: agreement, event: @event, ticket: @ticket, amount: bom.total_cost, status: AccountingEntry::STATUS_CLEARED, description: "Material Reimbursement to subcon")
      end
    end
    entries
  end

  def cparty_charge_entries
    entries = []
    entries << IncomeFromProvider.new(agreement: agreement, event: @event, ticket: @ticket, amount: counterparty_cut, status: AccountingEntry::STATUS_CLEARED,description: "Entry to subcontractor owned account")
    @ticket.boms.each do |bom|
      if bom.mine?
        entries << MaterialReimbursement.new(agreement: agreement, event: @event, ticket: @ticket, amount: bom.total_cost, status: AccountingEntry::STATUS_CLEARED, description: "Material Reimbursement to subcon")
      end
    end

    entries
  end


end
