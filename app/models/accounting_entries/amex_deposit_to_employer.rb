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
#

class AmexDepositToEmployer < AccountingEntry
  def amount_direction
    1
  end

end
