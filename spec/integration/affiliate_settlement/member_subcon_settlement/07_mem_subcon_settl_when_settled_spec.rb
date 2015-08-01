require 'spec_helper'

describe 'Member Subcon Settlement: When settled' do

  include_context 'transferred job'
  let(:subcon_entry1) { subcon_job.entries.where(type: AffiliateSettlementEntry.descendants.map(&:name)).order('id asc').first }
  let(:subcon_entry2) { subcon_job.entries.where(type: AffiliateSettlementEntry.descendants.map(&:name)).order('id asc').last }

  before do
    transfer_the_job
    accept_the_job subcon_job
    job.reload
    settle_with_subcon job, amount: 10, type: 'cheque'
    subcon_entry1.confirm!
    subcon_job.reload
    with_user(subcon_admin) do
      settle_with_provider subcon_job, amount: 100, type: 'cash'
    end
    start_the_job subcon_job
    add_bom_to_job subcon_job, cost: 10, price: 100, buyer: subcon, quantity: 1
    complete_the_work subcon_job
    job.reload
  end

  it 'the subcon status to change to claim_settled' do
    expect(job.subcontractor_status_name).to eq :claim_settled
  end

  context 'when the cheque is deposited' do
    before do
      subcon_entry1.deposit!
    end

    it 'provider entry is set to deposited' do
      expect(subcon_entry1.matching_entry.reload.status_name).to eq :deposited
    end


    context 'when the cheque is rejected' do
      before do
        subcon_entry2.confirm!
      end

      it 'rejecting teh cheque should change the status to rejected' do
        expect {
          subcon_entry1.reject!
          job.reload
        }.to change(job.reload, :subcontractor_status_name).from(:settled).to(:rejected)
      end

      it 'rejecting the cheque should reverse the balance' do
        expect {
          subcon_entry1.reject!
          job.reload
        }.to change(job, :subcon_balance).by(subcon_entry1.amount)
      end

    end

    context 'when the check is cleared and cash deposited' do
      before do
        subcon_entry1.clear!
        subcon_entry2.confirm!
        subcon_entry2.deposit!
      end

      it 'provider entry is set to cleared' do
        expect(subcon_entry1.matching_entry.reload.status_name).to eq :cleared
      end


      it 'the subcon status should change to cleared' do
        expect(job.reload.subcontractor_status_name).to eq :cleared
      end

    end
  end


end