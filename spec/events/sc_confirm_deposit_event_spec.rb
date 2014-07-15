require 'spec_helper'

describe ScConfirmDepositEvent do
  let(:event) { ScConfirmDepositEvent.new(eventable: ticket, entry_id: entry.id) }
  include_context 'entry event mocks'

  it 'should respond to entry_id' do
    expect(event).to respond_to(:entry_id)
  end

  it 'should create ScDepositConfirmedEvent when processing' do
    AccountingEntry.stub(:where).and_return(entry)
    ScDepositConfirmedEvent.should_receive(:new).with(hash_including(entry_id: entry.id))
    event.init
    event.process_event
  end

  describe 'when created' do

    before do
      Account.stub(:for_affiliate => [acc])
      ScConfirmDepositEvent.stub(:new).with(kind_of(Hash)).and_return(event)
      Event.stub_chain(:where, :where).and_return([event])
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