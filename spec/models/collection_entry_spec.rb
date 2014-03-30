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

describe CollectionEntry do

  #let(:ticket) {mock_model(Ticket, events: [])}
  #let(:account) {mock_model(Account, events: [])}
  #let(:agreement) {mock_model(Agreement, events: [])}
  #let(:event) {mock_model(Event, events: [])}
  #let(:entry) { CollectionEntry.new(ticket: ticket, account: account, agreement: agreement, event: event, description: 'test') }

  include_context 'entry mocks' do
    let(:klass) { CollectionEntry }
  end


  it 'default status should be :pending' do
    expect(entry.status_name).to eq :pending
  end

  describe '#deposit' do
    it 'should change the status to :deposited' do
      entry.deposit(false)
      expect(entry.status_name).to eq :deposited
    end

    it 'should generate a deposit event' do
      e = double
      ScDepositEvent.stub(new: e)
      ScDepositEvent.should_receive(:new)
      entry.deposit(false)
    end

    it 'there should be no available status events' do
      entry.deposit(false)
      expect(entry.status_name).to eq :deposited
      expect(entry.status_events).to eq [:clear]
    end
  end

  describe '#clear' do
    it 'should not be permitted for a user' do
      expect(entry.allowed_status_events).to eq [:deposit]
    end

    it 'should change the status to cleared' do
      entry.clear(false)
      expect(entry.status_name).to eq :cleared
    end
  end

end
