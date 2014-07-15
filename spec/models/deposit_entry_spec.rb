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

describe DepositEntry do

  include_context 'entry mocks' do
    let(:klass) { DepositEntry }
  end

  it 'status should be pending' do
    expect(entry.status_name).to eq :pending
  end

  describe '#confirm' do

    it 'should change the status to confirmed' do
      entry.confirm(false)
      expect(entry.status_name).to eq :confirmed
    end

    it 'should have no available status events' do
      entry.confirm(false)
      expect(entry.status_events).to eq []
    end

    it 'should trigger deposit confirmed event' do
      e = double
      ScConfirmDepositEvent.stub(new: e)
      ScConfirmDepositEvent.should_receive(:new)
      entry.confirm(false)
    end

  end
  describe '#dispute' do

    it 'should change the status to disputed' do
      entry.dispute(false)
      expect(entry.status_name).to eq :disputed
    end

    it 'should have no available status events' do
      entry.dispute(false)
      expect(entry.status_events).to eq [:confirm]
    end

    it 'should trigger deposit rejected event' do
      e = double
      AccAdjRejectEvent.stub(new: e)
      AccAdjRejectEvent.should_receive(:new)
      entry.dispute(false)
    end

  end

end
