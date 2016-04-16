require 'spec_helper'

describe 'Local Subcon Settlement: When rejected' do

  include_context 'job transferred to local subcon'
  let(:entry1) { job.entries.where(type: AffiliateSettlementEntry.descendants.map(&:name)).order('id asc').first }
  let(:entry2) { job.entries.where(type: AffiliateSettlementEntry.descendants.map(&:name)).order('id asc').last }

  before do
    transfer_the_job
    accept_on_behalf_of_subcon job
    settle_with_subcon job, amount: 10, type: 'cheque'
    entry1.confirmed!
    entry1.deposited!
    job.reload
  end

  it 'rejecting the entry should change the status' do
    expect {
      entry1.rejected!
      job.reload
    }.to change(job, :subcontractor_status_name).to(:rejected)
  end


  it 'rejecting the entry should change the subcontractor balance' do
    expect {
      entry1.rejected!
      job.reload
    }.to change(job, :subcon_balance).by(-entry1.amount)
  end


  context 'when the subcon rejects and then settles the remainder' do
    before do
      entry1.rejected!
      job.reload
    end

    context 'before the job is done' do
      before do
        settle_with_subcon job, amount: 100, type: 'cash'
        job.reload
      end

      it 'status should change to :partially_settled' do
        expect(job.subcontractor_status_name).to eq :partially_settled
      end

      context 'when the job is completed' do
        before do
          start_the_job job
          add_bom_to_job job, cost: 10, price: 100, buyer: subcon, quantity: 1, buyer: subcon
          complete_the_work job
          job.reload
        end

        it 'subcon status should remain partially_settled' do
          expect(job.subcontractor_status_name).to eq :partially_settled
        end

      end

    end
  end

  context 'when rejecting and then paying the subcon again' do
    before do
      entry1.rejected!
      job.reload
      settle_with_subcon job, amount: 10, type: 'cheque'
      job.reload
    end

    it 'should change the subcontractor status to partially_settled' do
      expect(job.subcontractor_status_name).to eq :partially_settled
    end
  end


  context 'when the cheque is rejected' do

    it 'rejecting the cheque should change the status to rejected' do
      expect {
        entry1.rejected!
        job.reload
      }.to change(job, :subcontractor_status_name).from(:partially_settled).to(:rejected)
    end

    it 'rejecting the cheque should reverse the balance' do
      expect {
        entry1.rejected!
        job.reload
      }.to change(job, :subcon_balance).by(-entry1.amount)
    end

  end

  context 'when settling again and rejecting' do
    before do
      settle_with_subcon job, amount: 20, type: 'cheque'
      job.reload
      entry2.confirmed!
      entry2.deposited!
      entry2.rejected!
    end
    context 'when the check is cleared' do
      before do
        entry1.cleared!
        job.reload
      end

      it 'the subcon status should remain partially_settled' do
        expect(job.subcontractor_status_name).to eq :rejected
      end

    end
  end


  context 'when competing the job and then rejecting the first payment' do
    before do
      start_the_job job
      add_bom_to_job job, cost: 10, price: 100, buyer: subcon, quantity: 1, buyer: subcon
      complete_the_work job
      entry1.rejected!
      job.reload
    end

    it 'should have a balance of 100 (as the bom reimbursement was already paid)' do
      expect(job.subcon_balance).to eq Money.new(-11000)
    end

    context 'when settling for the full amount' do
      before do
        settle_with_subcon job, amount: 110, type: 'credit_card'
        job.reload
      end

      it 'should change the status as settled' do
        expect(job.subcontractor_status_name).to eq :settled
      end

    end
  end

  context 'before completing the work' do
    context 'when the provider pays the subcon the reminder' do
      before do
        settle_with_subcon job, amount: 100, type: 'credit_card'
        job.reload
        entry2.confirmed!
        entry2.deposited!
        entry2.rejected!

        job.reload
      end

      it 'subcon status should be rejected' do
        expect(job.subcontractor_status_name).to eq :rejected
      end

      context 'when competing the work' do
        before do
          start_the_job job
          add_bom_to_job job, cost: 10, price: 100, buyer: subcon, quantity: 1, buyer: subcon
          complete_the_work job
          job.reload
        end

        it 'subcon status should remain to rejected' do
          expect(job.subcontractor_status_name).to eq :rejected
        end

      end


    end
  end

end