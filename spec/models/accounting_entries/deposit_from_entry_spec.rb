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

describe DepositFromEntry do
  include_context 'entry mocks' do
    let(:klass) { DepositFromEntry }
  end

  it 'should have submitted status' do
    expect(entry.status_name).to eq :submitted
  end

  it 'should have confirm and dispute events avilable' do
    expect(entry.status_events).to eq [:dispute, :confirm]
  end

  describe '#dispute' do
    before do
      DepositEntryDisputeEvent.stub(new: event)
      entry.dispute(false) unless example.metadata[:skip_dispute]
    end

    it 'status should change to disputed' do
      expect(entry.status_name).to eq :disputed
    end

    it 'available status events should be confirm and canceled' do
      expect(entry.status_events).to eq [:confirm, :canceled]
    end

    it 'should create an EntryDisputeEvent', skip_dispute: true do
      DepositEntryDisputeEvent.should_receive(:new)
      entry.dispute(false)
    end

    describe '#canceled' do
      before do
        entry.canceled(false)
      end

      it 'should change the status to canceled' do
        expect(entry.status_name).to eq :canceled
      end
    end

  end

  describe '#confirm' do
    before do
      DepositEntryConfirmEvent.stub(new: event)
      entry.confirm(false) unless example.metadata[:skip_confirm]
    end

    it 'status should change to confirmed' do
      expect(entry.status_name).to eq :confirmed
    end
  end

end
