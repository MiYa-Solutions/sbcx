require 'spec_helper'

describe 'Local Subcon Settlement: When settled' do

  include_context 'job transferred to local subcon'
  let(:entry1) { job.entries.where(type: AffiliateSettlementEntry.descendants.map(&:name)).order('id asc').first }
  let(:entry2) { job.entries.where(type: AffiliateSettlementEntry.descendants.map(&:name)).order('id asc').last }

  before do
    transfer_the_job
    accept_on_behalf_of_subcon job
    job.reload
    settle_with_subcon job, amount: 10, type: 'cheque'
    entry1.confirmed!
    job.reload
    settle_with_subcon job, amount: 100, type: 'cash'
    start_the_job job
    add_bom_to_job job, cost: 10, price: 100, buyer: subcon, quantity: 1
    complete_the_work job
    job.reload
  end

  it 'the subcon status to settled' do
    expect(job.reload.subcontractor_status_name).to eq :settled
  end

  context 'when the cheque is deposited' do
    before do
      entry1.deposited!
    end


    context 'when the cheque is rejected' do

      it 'rejecting teh cheque should change the status to rejected' do
        expect {
          entry1.rejected!
          job.reload
        }.to change(job, :subcontractor_status_name).from(:settled).to(:rejected)
      end

      it 'rejecting the cheque should reverse the balance' do
        expect {
          entry1.rejected!
          job.reload
        }.to change(job, :subcon_balance).by(-entry1.amount)
      end

    end

    context 'when the check is cleared and cash deposited' do
      before do
        entry1.cleared!
        entry2.confirmed!
        entry2.deposited!
      end

      it 'the subcon status should remain partially_settled' do
        expect(job.reload.subcontractor_status_name).to eq :cleared
      end

    end
  end


end