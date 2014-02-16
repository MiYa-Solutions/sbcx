require 'spec_helper'

describe EntryDisputedEvent do

  include_context 'entry event mocks' do
    let(:event) { EntryDisputedEvent.new(eventable: ticket, entry_id: entry.id, triggering_event: mock_model(EntryDisputeEvent)) }
  end

  context 'when created' do

    before do
      acc.stub(adjustment_accepted: true)
      entry.stub(matching_entry: orig_entry)
      orig_entry.stub(matching_entry: entry)
      Account.stub(:for_affiliate => [acc])
      AccountingEntry.stub(:find).with('1').and_return(orig_entry)
      AccountingEntry.stub(:find).with('2').and_return(entry)
      Event.stub_chain(:where, :where).and_return([adj_event])
    end

    it 'should change the entry status to disputed' do
      orig_entry.should_receive(:disputed!)
      event.save!
    end

  end


  context 'validation' do

    before do
      event.valid?
    end

    it 'the event should be valid' do
      expect(event).to be_valid
    end

    it 'should have a reference id of 300012' do
      expect(event.reference_id).to be 300012
    end

    it 'should have a description taken from I18n' do
      expect(event.description).to eq I18n.t('entry_disputed_event.description')
    end

    it 'should have a description taken from I18n' do
      expect(event.name).to eq I18n.t('entry_disputed_event.name')
    end
  end
end