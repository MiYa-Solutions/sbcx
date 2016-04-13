require 'spec_helper'

describe 'Local Subcon Settlement: When partially_settled' do

  include_context 'job transferred to local subcon'
  let(:entry1) { job.entries.where(type: AffiliateSettlementEntry.descendants.map(&:name)).order('id asc').first }
  let(:entry2) { job.entries.where(type: AffiliateSettlementEntry.descendants.map(&:name)).order('id asc').last }

  before do
    transfer_the_job
    accept_on_behalf_of_subcon job
    settle_with_subcon job, amount: 10, type: 'cheque'
    entry1.confirmed!
    job.reload
  end

  it 'the subcon status to partially_settled' do
    expect(job.reload.subcontractor_status_name).to eq :partially_settled
  end

  context 'when over-paying the subcon' do
    before do
      settle_with_subcon job, amount: 1000, type: 'cash'
      entry2.confirmed!
      entry2.deposit!
      job.reload
    end

    it 'the status should be partially_settled' do
      expect(job.subcontractor_status_name).to eq :partially_settled
    end

    context 'when competing the job' do
      before do
        start_the_job job
        add_bom_to_job job, cost: 10, price: 100, buyer: subcon, quantity: 1, buyer: subcon
        complete_the_work job
        job.reload
      end

      it 'the subcon status remains partially_settled' do
        expect(job.reload.subcontractor_status_name).to eq :partially_settled
      end


      it 'should have a balance of 100 (as the bom reimbursement was already paid)' do
        expect(job.subcon_balance).to eq Money.new(90000)
      end

      context 'when submitting payment for the balance to constitute a reimbursement' do
        before do
          settle_with_subcon job, amount: -90000, type: 'cash'
        end

        it 'subcon status should change to settled' do
          expect(job.reload.subcontractor_status_name).to eq :settled
        end

      end

    end  end

  context 'when paying the subcon again' do
    before do
      settle_with_subcon job, amount: 10, type: 'cheque'
      job.reload
    end

    it 'should change the subcontractor status to partially_settled' do
      expect(job.subcontractor_status_name).to eq :partially_settled
    end
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
        }.to change(job, :subcontractor_status_name).from(:partially_settled).to(:rejected)
      end

      it 'rejecting the cheque should reverse the balance' do
        expect {
          entry1.rejected!
          job.reload
        }.to change(job, :subcon_balance).by(-entry1.amount)
      end

    end

    context 'when the check is cleared' do
      before do
        entry1.cleared!
      end

      it 'the subcon status should remain partially_settled' do
        expect(job.reload.subcontractor_status_name).to eq :partially_settled
      end

    end
  end


  context 'when competing the job' do
    before do
      start_the_job job
      add_bom_to_job job, cost: 10, price: 100, buyer: subcon, quantity: 1, buyer: subcon
      complete_the_work job
      job.reload
    end

    it 'the subcon status remains partially_settled' do
      expect(job.reload.subcontractor_status_name).to eq :partially_settled
    end


    it 'should have a balance of 100 (as the bom reimbursement was already paid)' do
      expect(job.subcon_balance).to eq Money.new(-10000)
    end

    context 'when settling for the remaining amount' do
      before do
        settle_with_subcon job, amount: 100, type: 'credit_card'
      end

      it 'should change the status as claim_settled' do
        expect(job.subcontractor_status_name).to eq :settled
      end

    end
  end

  context 'before completing the work' do
    context 'when the provider pays the subcon the reminder' do
      before do
        settle_with_subcon job, amount: 100, type: 'credit_card'
        entry2.confirmed!
        job.reload
      end

      it 'subcon status should remain partially_settled' do
        expect(job.subcontractor_status_name).to eq :partially_settled
      end

      context 'when competing the work' do
        before do
          start_the_job job
          add_bom_to_job job, cost: 10, price: 100, buyer: subcon, quantity: 1
          complete_the_work job
          job.reload
        end

        it 'subcon status should change to settled' do
          expect(job.subcontractor_status_name).to eq :settled
        end

      end


    end
  end

end