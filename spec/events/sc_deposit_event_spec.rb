require 'spec_helper'

describe ScDepositEvent do


  include_context 'entry event mocks' do
    let(:event) { ScDepositEvent.new(eventable: ticket, entry_id: entry.id, amount: entry.amount) }
  end

  before do
    Account.stub_chain(:for_affiliate, :lock, :first).and_return(acc)
    AccountingEntry.stub(find: entry)
    event.init
  end


  it 'should have ref id of 100022' do
    expect(event.reference_id).to eq 100022
  end

  it 'should respond to amount' do
    expect(event).to respond_to(:amount)
  end

  context 'when processing the event' do

    context 'when depositing a cash entry' do
      let(:entry) { mock_model(CashCollectionForProvider, amount: Money.new(1000)) }

      it 'should create a cash deposit entry' do
        CashDepositToProvider.stub(new: double)
        CashDepositToProvider.should_receive(:new).with(hash_including(amount: event.amount))
        event.process_event
      end
    end
    context 'when depositing a amex entry' do
      let(:entry) { mock_model(AmexCollectionForProvider, amount: Money.new(1000)) }

      it 'should create a cash deposit entry' do
        AmexDepositToProvider.stub(new: double)
        AmexDepositToProvider.should_receive(:new).with(hash_including(amount: event.amount))
        event.process_event
      end
    end
    context 'when depositing a credit card entry' do
      let(:entry) { mock_model(CreditCardCollectionForProvider, amount: Money.new(1000)) }

      it 'should create a cash deposit entry' do
        CreditCardDepositToProvider.stub(new: double)
        CreditCardDepositToProvider.should_receive(:new).with(hash_including(amount: event.amount))
        event.process_event
      end
    end
    context 'when depositing a cheque entry' do
      let(:entry) { mock_model(ChequeCollectionForProvider, amount: Money.new(1000)) }

      it 'should create a cash deposit entry' do
        ChequeDepositToProvider.stub(new: double)
        ChequeDepositToProvider.should_receive(:new).with(hash_including(amount: event.amount))
        ticket.should_receive(:payment_deposited).with(entry)
        event.process_event
      end

    end
  end


end