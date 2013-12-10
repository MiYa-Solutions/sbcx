require 'spec_helper'

describe AccountAdjustmentEvent do

  let(:org) { mock_model(Organization, id: 1, name: 'Test Org1', providers: [], subcontractors: []) }
  let(:org2) { mock_model(Organization, id: 2, name: 'Test Org2', providers: [], subcontractors: []) }
  let(:acc) { mock_model(Account, id: 1, name: 'Test Org', organization: org, accountable: org2, events: []) }
  let(:entry) { mock_model(MyAdjEntry, id: 1, save: true) }
  let(:event) { AccountAdjustmentEvent.new(eventable: acc, entry_id: entry.id) }


  context 'when created' do

    before do
      Account.stub(:for_affiliate => [acc])
    end

    it 'should create AccountAdjustedEvent' do
      AccountAdjustedEvent.should_receive(:new)
      event.save
    end

    it 'should save the entry id in the properties' do
      event.save
      expect(event.properties).to eq({ 'entry_id' => '1' })
      expect(event.entry_id).to eq '1'
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
      expect(event.reference_id).to be 300000
    end

    it 'should have a description taken from I18n' do
      expect(event.description).to eq I18n.t('account_adjustment_event.description')
    end

    it 'should have a description taken from I18n' do
      expect(event.name).to eq I18n.t('account_adjustment_event.name')
    end
  end
end