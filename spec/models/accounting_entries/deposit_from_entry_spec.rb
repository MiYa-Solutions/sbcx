require 'spec_helper'

describe DepositFromEntry do
  include_context 'entry mocks' do
    let(:klass) { DepositFromEntry }
  end

  it 'should have submitted status' do
    expect(entry.status_name).to eq :submitted
  end

  it 'should have confirm and dispute events avilable' do
    expect(entry.status_events).to eq [:dispute, :confirm]
  end

  describe '#dispute' do
    before do
      EntryDisputeEvent.stub(new: event)
      entry.dispute(false) unless example.metadata[:skip_dispute]
    end

    it 'status should change to disputed' do
      expect(entry.status_name).to eq :disputed
    end

    it 'available status events should be confirm and canceled' do
      expect(entry.status_events).to eq [:confirm, :canceled]
    end

    it 'should create an EntryDisputeEvent', skip_dispute: true do
      EntryDisputeEvent.should_receive(:new)
      entry.dispute(false)
    end

    describe '#canceled' do
      before do
        entry.canceled(false)
      end

      it 'should change the status to canceled' do
        expect(entry.status_name).to eq :canceled
      end
    end

  end

  describe '#confirm' do
    before do
      EntryConfirmEvent.stub(new: event)
      entry.confirm(false) unless example.metadata[:skip_confirm]
    end

    it 'status should change to confirmed' do
      expect(entry.status_name).to eq :confirmed
    end
  end

end