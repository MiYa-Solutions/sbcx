# == Schema Information
#
# Table name: accounting_entries
#
#  id                :integer          not null, primary key
#  status            :integer
#  event_id          :integer
#  amount_cents      :integer          default(0), not null
#  amount_currency   :string(255)      default("USD"), not null
#  ticket_id         :integer
#  account_id        :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  type              :string(255)
#  description       :string(255)
#  balance_cents     :integer          default(0), not null
#  balance_currency  :string(255)      default("USD"), not null
#  agreement_id      :integer
#  external_ref      :string(255)
#  collector_id      :integer
#  collector_type    :string(255)
#  matching_entry_id :integer
#

class AffiliateSettlementEntry < AccountingEntry

  has_many :events, as: :eventable



  STATUS_REJECTED = 9001

  state_machine :status do

    state :rejected, value: STATUS_REJECTED

    event :reject do
      transition :deposited => :rejected
    end

    event :clear do
      transition :deposited => :cleared
    end

    event :deposit do
      transition :confirmed => :deposited
    end

  end


end
