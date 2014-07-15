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
class CollectedEntry < PaymentEntry
  include Collectible

  STATUS_SUBMITTED = 4000

  state_machine :status, initial: :submitted do
    state :submitted, value: STATUS_SUBMITTED

    event :deposited do
      transition :submitted => :deposited
    end

    event :cleared do
      transition :deposited => :cleared
    end

  end

  def allowed_status_events
    if account.accountable.member?
      []
    else
      self.status_events & [:deposited]
    end

  end
end
