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

describe DepositToEntry do
  include_context 'entry mocks' do
    let(:klass) { DepositToEntry }
  end

  it 'status should be submitted' do
    expect(entry.status_name).to eq :submitted
  end

  it 'available status events should be dispute or confirm' do
    expect(entry.status_events).to eq [:confirmed, :disputed]
  end

  describe '#disputed' do
    before do
      entry.disputed(false)
    end
    it 'should change status to disputed' do
      expect(entry.status_name).to eq :disputed
    end

    it 'should allow to confirm or cancel after disputed' do
      expect(entry.status_events).to eq [:confirmed, :cancel]
    end

    describe '#cancel' do
      before do
        EntryCancelEvent.stub(new: event)
        entry.cancel(false) unless example.metadata[:skip_cancel]
      end

      it 'status should change to canceled' do
        expect(entry.status_name).to eq :canceled
      end

      it 'there should be no available status events' do
        expect(entry.status_events).to eq []
      end

      it 'should create an EntryCancelEvent', skip_cancel: true do
        EntryCancelEvent.should_receive(:new)
        entry.cancel(false)
      end

    end
  end

  describe '#confirmed' do
    before do
      entry.confirmed(false)
    end
    it 'should change status to disputed' do
      expect(entry.status_name).to eq :confirmed
    end

    it 'should not allow any other events as confirmed is the last one' do
      expect(entry.status_events).to eq []
    end
  end


end
