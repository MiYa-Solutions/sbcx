require 'spec_helper'

describe 'Affiliate Entry When Transfer to Local' do

  include_context 'job transferred to local subcon'
  let(:entry1) { job.entries.where(type: AffiliateSettlementEntry.descendants.map(&:name)).order('id asc').first }
  let(:entry2) { job.entries.where(type: AffiliateSettlementEntry.descendants.map(&:name)).order('id asc').last }

  before do
    transfer_the_job
    accept_on_behalf_of_subcon job
    start_the_job job
    add_bom_to_job job, cost: 100, price: 1000, quantity: 1, buyer: subcon
    complete_the_work job
    job.reload
  end


  context 'when the provider initiates the settlement' do

    before do
      settle_with_subcon job, type: 'cheque', amount: '10'
    end

    it 'subcon entry should be valid' do
      expect(entry1).to be_valid
    end

    it 'subcon entry events should be confirm and dispute' do
      expect(entry1.allowed_status_events.sort).to eq [:confirmed, :disputed]
    end


    context 'when the subcon confirms the payment' do
      before do
        entry1.confirmed!
      end

      it 'subcon entry events should be confirm and dispute' do
        expect(entry1.allowed_status_events).to eq [:deposited]
      end

      it 'subcon entry status should be confirmed' do
        expect(entry1.status_name).to eq :confirmed
      end

      context 'when the subcon deposits the payment' do
        before do
          entry1.deposited!
        end

        it 'subcon entry status should be confirmed' do
          expect(entry1.status_name).to eq :deposited
        end

      end
    end

  end

end