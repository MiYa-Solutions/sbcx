require 'spec_helper'

describe MyAdjEntry do

  let(:org) { mock_model(Organization, id: 1) }
  let(:org2) { mock_model(Organization, id: 2) }
  let(:acc) { mock_model(Account, id: 1, organization: org, accountable: org2, changed_for_autosave?: true, save: true, events: []) }
  let(:event) { mock_model(Event, id: 1) }
  let(:ticket) { mock_model(Ticket, id: 1, save: true, ref_id: 1) }
  let(:entry) { MyAdjEntry.new(ticket: ticket, account: acc, event: event, description: 'test', ticket_ref_id: ticket.id) }

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
    let(:event) { mock_model(AccountAdjustmentEvent, save: true, :[]= => true, process_event: true, :eventable_id => 1, eventable_type: 'Account', properties: {}) }
    before do
      AccountAdjustmentEvent.stub(:new => event)
      entry.stub(:the_ticket => ticket)
    end

    context 'when the affiliate is a subcon_member' do
      before do
        org2.stub(subcontrax_member?: true)
        org2.stub(member?: true)
        org.stub(subcontrax_member?: true)
        org.stub(member?: true)
      end

      it 'should create a AccountAdjustment event' do
        AccountAdjustmentEvent.should_receive(:new).with(kind_of(Hash))
        entry.save!
      end

      it 'entry status should be submitted a AccountAdjustment event' do
        entry.save!
        expect(entry.status).to eq MyAdjEntry::STATUS_SUBMITTED
      end

    end

    context 'when the affiliate is NOT a subcon_member' do
      before do
        org2.stub(subcontrax_member?: false)
        org2.stub(member?: false)
      end

      it 'should create a AccountAdjustment event' do
        AccountAdjustmentEvent.should_not_receive(:new)
        entry.save!
      end

      it 'entry status should be submitted a AccountAdjustment event' do
        entry.save!
        expect(entry.status).to eq MyAdjEntry::STATUS_CLEARED
      end

    end
  end

  context 'when accepted' do

    describe 'when affiliate is a member' do
      before do
        org2.stub(subcontrax_member?: true)
        org2.stub(member?: true)
        org.stub(subcontrax_member?: true)
        org.stub(member?: true)
        Ticket.stub(where: [ticket])
        entry.save
        entry.accept(false)
      end

      it 'should have an accept method which will transition to accepted' do
        expect(entry).to be_accepted
      end
    end
  end


  context 'when rejected' do
    context 'when the affiliate is a member' do
      before do
        org2.stub(subcontrax_member?: true)
        org2.stub(member?: true)
        org2.stub(subcontrax_member?: true)
        org2.stub(member?: true)
        org.stub(subcontrax_member?: true)
        org.stub(member?: true)
        Ticket.stub(where: [ticket])
        entry.save
        entry.reject(false)
      end
      it 'should have a reject method which will transition to rejected' do
        expect(entry).to be_rejected
      end
    end
  end


end