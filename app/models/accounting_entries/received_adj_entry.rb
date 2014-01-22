# == Schema Information
#
# Table name: accounting_entries
#
#  id               :integer          not null, primary key
#  status           :integer
#  event_id         :integer
#  amount_cents     :integer          default(0), not null
#  amount_currency  :string(255)      default("USD"), not null
#  ticket_id        :integer
#  account_id       :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  type             :string(255)
#  description      :string(255)
#  balance_cents    :integer          default(0), not null
#  balance_currency :string(255)      default("USD"), not null
#  agreement_id     :integer
#

#require 'adjustment_entry'
class ReceivedAdjEntry < AdjustmentEntry


  ##
  # State machines
  ##

  state_machine :status, initial: :pending do
    state :rejected, value: STATUS_REJECTED
    state :accepted, value: STATUS_ACCEPTED
    state :pending, value: STATUS_PENDING

    event :accept do
      transition :pending => :accepted
    end

    event :reject do
      transition :pending => :rejected
    end

  end

  def allowed_status_events
    self.status_events & [:accept, :reject]
  end


  private


end
