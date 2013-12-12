require 'spec_helper'

describe AccountAdjustedEvent do

  let(:org) { mock_model(Organization, id: 1, name: 'Test Org1', providers: [], subcontractors: []) }
  let(:org2) { mock_model(Organization, id: 2, name: 'Test Org2', providers: [], subcontractors: []) }
  let(:acc) { mock_model(Account, id: 1, name: 'Test Org', organization: org, accountable: org2, events: [], entries: []) }
  let(:orig_entry) { mock_model(MyAdjEntry, id: '1', save: true, amount: Money.new_with_amount(100)) }
  let(:entry) { mock_model(ReceivedAdjEntry, id: '2', save: true, amount: Money.new_with_amount(100)) }
  let(:invoking_event) { mock_model(AccountAdjustmentEvent, eventable: acc, entry_id: 1) }
  let(:event) { AccountAdjustedEvent.new(eventable: acc, triggering_event: invoking_event) }


  context 'when created' do

    before do
      Account.stub(:for_affiliate => [acc])
      AccountingEntry.stub(:find).with(1) { orig_entry }
      AccountingEntry.stub(:find).with(2) { entry }
      ReceivedAdjEntry.stub(new: entry)
    end

    it 'should create ReceivedAdjEntry' do
      ReceivedAdjEntry.should_receive(:new)
      acc.entries.should_receive(:<<).with(entry)
      event.save!
    end

    it 'should have the original entry id in the properties' do
      event.save!
      expect(event.matching_entry_id).to eq orig_entry.id
    end

    it 'should have the new entry id in the properties' do
      event.save
      expect(event.entry_id).to eq entry.id
    end
  end


  context 'validation' do

    before do
      event.valid?
    end

    it 'the event should be valid' do
      expect(event).to be_valid
    end

    it 'should have a reference id of 2' do
      expect(event.reference_id).to be 300001
    end

    it 'should have a description taken from I18n' do
      expect(event.description).to eq I18n.t('account_adjusted_event.description')
    end

    it 'should have a description taken from I18n' do
      expect(event.name).to eq I18n.t('account_adjusted_event.name')
    end
  end
end