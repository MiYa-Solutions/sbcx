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

require 'spec_helper'

describe AdjustmentEntry do

  let(:entry) { AdjustmentEntry.new }

  context 'validation' do
    it { expect(entry).to validate_numericality_of(:ticket_ref_id) }
    it { expect(entry).to_not validate_presence_of(:agreement) }
  end

  context 'association' do
    it { expect(entry).to belong_to(:ticket) }

  end

  context 'api' do
    it 'sets the ticket to be the one specified in ticket_ref_id' do
      #ticket = FactoryGirl.create(:my_service_call)
      #entry.ticket_ref_id = ticket.id
      #expect(entry.save).to be_true
      #
      #expect(entry.ticket).to be ticket
      pending
    end

  end
end
