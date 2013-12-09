require 'spec_helper'

describe MyAdjEntry do

  let(:acc) { mock_model(Account, id: 1) }
  let(:event) { mock_model(Event, id: 1) }
  let(:ticket) { mock_model(Ticket, id: 1) }
  let(:entry) { MyAdjEntry.new(ticket: ticket, account: acc, event: event, description: 'test', ticket_ref_id: 1) }

  it 'should have a state machine constants defined for the various states' do
    expect(entry.class).to have_constant(:STATUS_SUBMITTED)
    expect(entry.class).to have_constant(:STATUS_ACCEPTED)
    expect(entry.class).to have_constant(:STATUS_REJECTED)
  end


  it 'should respond to submitted?' do
    expect(entry).to respond_to(:submitted?)
  end

  it 'should respond to rejected?' do
    expect(entry).to respond_to(:rejected?)
  end

  it 'should respond to accepted?' do
    expect(entry).to respond_to(:accepted?)
  end

  context 'when created' do
    it 'should create create matching ReceivedAdjEntry' do

    end
  end

  context 'when accepted' do
    before do
      entry.accept(false)
    end

    it 'should have an accept method which will transition to accepted' do
      expect(entry).to be_accepted
    end
  end


  context 'when rejected' do
    it 'should have an accept method which will transition to rejected' do
      entry.reject(false)
      expect(entry).to be_rejected
    end
  end


end