require 'spec_helper'

describe 'local Subcon Settlement: When settled' do

  include_context 'job transferred from a local provider' do
    let(:collection_allowed?) { true }
    let(:transfer_allowed?) { true }
  end
  let(:entry1) { job.entries.where(type: AffiliateSettlementEntry.descendants.map(&:name)).order('id asc').first }
  let(:entry2) { job.entries.where(type: AffiliateSettlementEntry.descendants.map(&:name)).order('id asc').last }

  before do
    accept_the_job job
    job.reload
    settle_with_provider job, amount: 10, type: 'cheque'
    entry1.confirm!
    job.reload
    settle_with_provider job, amount: 100, type: 'cash'
    start_the_job job
    add_bom_to_job job, cost: 10, price: 100, quantity: 1
    complete_the_work job
    job.reload
  end

  it 'the provider status to settled' do
    expect(job.provider_status_name).to eq :settled
  end

  context 'when the cheque is deposited' do
    before do
      entry1.deposit!
    end

    context 'when the cheque is rejected' do

      it 'rejecting the cheque should change the status to rejected' do
        expect {
          entry1.reject!
          job.reload
        }.to change(job, :provider_status_name).from(:settled).to(:rejected)
      end

      it 'rejecting the cheque should reverse the balance' do
        expect {
          entry1.reject!
          job.reload
        }.to change(job, :provider_balance).by(-entry1.amount)
      end

    end

    context 'when the check is cleared and cash deposited' do
      before do
        entry1.clear!
        entry2.confirm!
        entry2.deposit!
      end

      it 'the provider status should remain partially_settled' do
        expect(job.reload.provider_status_name).to eq :cleared
      end

    end
  end


end