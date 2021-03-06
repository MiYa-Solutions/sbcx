require 'spec_helper'

describe AccAdjAcceptEvent do

  include_context 'entry event mocks' do
    let(:event) { AccAdjAcceptEvent.new(eventable: acc, entry_id: entry.id) }
  end

  context 'when created' do

    before do
      acc.stub(adjustment_accepted: true)
      Account.stub(:for_affiliate => [acc])
      AccAdjAcceptedEvent.stub(:new).with(kind_of(Hash)).and_return(double('AccAdjAcceptedEvent'))
      Event.stub_chain(:where, :where).and_return([adj_event])
    end

    it 'should create AccAdjAcceptEvent' do
      AccAdjAcceptedEvent.should_receive(:new)
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

    it 'should have a reference id of 300002' do
      expect(event.reference_id).to be 300002
    end

    it 'should have a description taken from I18n' do
      expect(event.description).to eq I18n.t('acc_adj_accept_event.description', entry_id: entry.id, aff: org2.name)
    end

    it 'should have a description taken from I18n' do
      expect(event.name).to eq I18n.t('acc_adj_accept_event.name')
    end
  end
end