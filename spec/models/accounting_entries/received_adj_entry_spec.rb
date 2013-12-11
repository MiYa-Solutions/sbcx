require 'spec_helper'

describe MyAdjEntry do

  let(:org) { mock_model(Organization, id: 1) }
  let(:org2) { mock_model(Organization, id: 2) }
  let(:acc) { mock_model(Account, id: 1, organization: org, accountable: org2, changed_for_autosave?: true, save: true, events: []) }
  let(:event) { mock_model(Event, id: 1) }
  let(:ticket) { mock_model(Ticket, id: 1, save: true, ref_id: 1) }
  let(:entry) do
    e = ReceivedAdjEntry.new(ticket: ticket, account: acc, event: event, description: 'test', ticket_ref_id: ticket.id)
    e.stub(:the_ticket => ticket)
    e
  end

  it 'should have a state machine constants defined for the various states' do
    expect(entry.class).to have_constant(:STATUS_PENDING)
    expect(entry.class).to have_constant(:STATUS_ACCEPTED)
    expect(entry.class).to have_constant(:STATUS_REJECTED)
    expect(entry.class).to have_constant(:STATUS_CANCELED)
  end


  it 'should respond to pending?' do
    expect(entry).to respond_to(:pending?)
  end

  it 'should respond to rejected?' do
    expect(entry).to respond_to(:rejected?)
  end

  it 'should respond to accepted?' do

    expect(entry).to respond_to(:accepted?)
  end

  it 'should respond to accepted?' do

    expect(entry).to respond_to(:canceled?)
  end

  context 'when accepted' do
    let(:event) { mock_model(AccAdjAcceptEvent, id: 1) }
    before do
      AccAdjAcceptEvent.stub(:new).and_return(event)

    end

    it 'should have an accept method which will transition to accepted' do
      entry.accept(false)
      expect(entry).to be_accepted
    end

    it 'should create an AccAdjustmentAccepted event' do
      AccAdjAcceptEvent.should_receive(:new)
      #event.should_receive(:entry_id=)
      entry.accept(false)
    end
  end


  context 'when rejected' do
    it 'should have an accept method which will transition to rejected' do
      entry.reject(false)
      expect(entry).to be_rejected
    end
  end

  context 'when canceled' do
    it 'should have a cancel method which will transition to cancled' do
      entry.status = AdjustmentEntry::STATUS_REJECTED
      entry.cancel(false)
      expect(entry).to be_canceled
    end
  end

end