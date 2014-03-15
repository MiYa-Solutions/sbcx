require 'spec_helper'

describe DepositEntryDisputeEvent do

  include_context 'entry event mocks' do
    let(:event) { DepositEntryDisputeEvent.new(eventable: ticket, entry_id: orig_entry.id) }
  end

  context 'when created' do

    before do
      acc.stub(adjustment_accepted: true)
      entry.stub(matching_entry: orig_entry)
      orig_entry.stub(matching_entry: entry)
      Account.stub(:for_affiliate => [acc])
      AccountingEntry.stub(:find).with('1').and_return(orig_entry)
      AccountingEntry.stub(:find).with('2').and_return(entry)
      DepositEntryDisputedEvent.stub(:new).with(kind_of(Hash)).and_return(double('AccAdjAcceptedEvent'))
      Event.stub_chain(:where, :where).and_return([adj_event])
    end

    it 'should create EntryDisputedEvent when processing the event' do
      DepositEntryDisputedEvent.should_receive(:new)
      event.save!
    end

    it 'should save the entry id in the properties' do
      event.save!
      expect(event.entry_id).to eq orig_entry.id.to_s
    end

  end


  context 'validation' do

    before do
      event.valid?
    end

    it 'the event should be valid' do
      expect(event).to be_valid
    end

    it 'should have a reference id of 300011' do
      expect(event.reference_id).to be 300011
    end

    it 'should have a description taken from I18n' do
      expect(event.description).to eq I18n.t('entry_dispute_event.description')
    end

    it 'should have a description taken from I18n' do
      expect(event.name).to eq I18n.t('entry_dispute_event.name')
    end
  end
end