require 'spec_helper'

describe AccAdjRejectEvent do

  let(:org) { mock_model(Organization, id: 1, name: 'Test Org1', providers: [], subcontractors: []) }
  let(:org2) { mock_model(Organization, id: 2, name: 'Test Org2', providers: [], subcontractors: []) }
  let(:acc) { mock_model(Account, id: 1, name: 'Test Acc', organization: org, accountable: org2,
                         events:      [], balance: Money.new_with_amount(0),
                         :balance=    => Money.new_with_amount(-10), adjustment_rejected: true) }
  let(:orig_entry) { mock_model(MyAdjEntry, id: 1, save: true, amount: Money.new_with_amount(-10)) }
  let(:entry) { mock_model(ReceivedAdjEntry, id: 2, save: true, amount: Money.new_with_amount(10)) }
  let(:adj_event) { mock_model(AccountAdjustedEvent, id: 2, save: true, matching_entry_id: orig_entry.id) }
  let(:event) { AccAdjRejectEvent.new(eventable: acc, entry_id: entry.id) }


  context 'when created' do

    before do
      AccountingEntry.stub(:find).with(orig_entry.id.to_s) { orig_entry }
      AccountingEntry.stub(:find).with(entry.id.to_s) { entry }

      Account.stub(:for_affiliate => [acc])
      AccAdjRejectedEvent.stub(:new).with(kind_of(Hash)).and_return(double('AccAdjRejectedEvent'))
      Event.stub_chain(:where, :where).and_return([adj_event])
    end

    it 'should create AccAdjRejectedEvent' do
      AccAdjRejectedEvent.should_receive(:new)
      event.save!
    end

    it 'should save the entry id in the properties' do
      event.save!
      expect(event.entry_id).to eq entry.id.to_s
    end

  end


  context 'validation' do

    before do
      event.valid?
    end

    it 'the event should be valid' do
      expect(event).to be_valid
    end

    it 'should have a reference id of 300004' do
      expect(event.reference_id).to be 300004
    end

    it 'should have a description taken from I18n' do
      expect(event.description).to eq I18n.t('acc_adj_reject_event.description', entry_id: entry.id, aff: org2.name)
    end

    it 'should have a description taken from I18n' do
      expect(event.name).to eq I18n.t('acc_adj_reject_event.name')
    end
  end
end