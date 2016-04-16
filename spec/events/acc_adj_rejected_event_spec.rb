require 'spec_helper'

describe AccAdjRejectedEvent do

  let(:org) { mock_model(Organization, id: 1, name: 'Test Org1', providers: [], subcontractors: []) }
  let(:org2) { mock_model(Organization, id: 2, name: 'Test Org2', providers: [], subcontractors: []) }
  let(:acc) { mock_model(Account, id: 1, name: 'Test Acc', organization: org, accountable: org2,
                         events:      [], balance: Money.new_with_amount(0),
                         :balance=    => Money.new_with_amount(-10), adjustment_rejected: true) }
  let(:aff_acc) { mock_model(Account, id: 2, name: 'Test Aff Acc', organization: org2, accountable: org, events: [], entries: []) }
  let(:orig_entry) { mock_model(MyAdjEntry, id: '1', save: true, amount: Money.new_with_amount(100), reject!: true) }
  let(:entry) { mock_model(ReceivedAdjEntry, id: '2', save: true, amount: Money.new_with_amount(100), reject!: true) }
  let(:invoking_event) { mock_model(AccAdjRejectEvent, eventable: aff_acc, entry_id: entry.id) }
  let(:event) { AccAdjRejectedEvent.new(eventable: acc, triggering_event: invoking_event, entry_id: orig_entry.id) }


  context 'when created' do

    before do
      Account.stub(:for_affiliate => [acc])
      AccountingEntry.stub(:find).with('1') { orig_entry }
      AccountingEntry.stub(:find).with('2') { entry }
      ReceivedAdjEntry.stub(new: entry)
    end

    it 'should update the status of the original entry to rejected' do
      orig_entry.should_receive(:reject!)
      event.save!
    end

    it 'should have the original entry id in the properties' do
      event.save!
      expect(event.entry_id).to eq orig_entry.id
    end

  end


  context 'init attributes' do

    before do
      event.valid?
    end

    it 'the event should be valid' do
      expect(event).to be_valid
    end

    it 'should have a reference id of 300005' do
      expect(event.reference_id).to be 300005
    end

    it 'should have a description taken from I18n' do
      expect(event.description).to eq I18n.t('acc_adj_rejected_event.description', entry_id: orig_entry.id, aff: org2.name)
    end

    it 'should have a name taken from I18n' do
      expect(event.name).to eq I18n.t('acc_adj_rejected_event.name')
    end
  end
end