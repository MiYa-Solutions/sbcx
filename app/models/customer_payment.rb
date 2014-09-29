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

require 'collectible'
class CustomerPayment < AccountingEntry
  include Collectible

  has_many :events, as: :eventable

  STATUS_REJECTED = 9001

  state_machine :status, initial: :pending do

    state :rejected, value: STATUS_REJECTED

    event :reject do
      transition [:pending, :deposited] => :rejected
    end

    event :clear do
      transition [:pending, :deposited] => :cleared
    end

    event :deposit do
      transition :pending => :deposited
    end

  end

  def allowed_status_events
    matching_entry ? events_for_3rd_party_collection : the_status_events
  end

  private

  def events_for_3rd_party_collection
    if matching_entry.deposited? || matching_entry.cleared?
      the_status_events
    else
      []
    end
  end

  def the_status_events
    if deposited?
      [:clear, :reject]
    else
      self.status_events & [:deposit]
    end

  end

end
