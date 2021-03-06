require 'spec_helper'

describe 'Member Subcon Settlement: When rejected' do

  include_context 'transferred job'
  let(:subcon_entry1) { subcon_job.entries.order('id asc').first }
  let(:subcon_entry2) { subcon_job.entries.order('id asc').last }

  before do
    transfer_the_job
    accept_the_job subcon_job
    job.reload
    settle_with_subcon job, amount: 10, type: 'cheque'
    subcon_entry1.confirm!
    subcon_entry1.deposit!
    job.reload
  end

  it 'rejecting the entry should change the status' do
    expect {
      subcon_entry1.reject
      job.reload
    }.to change(job, :subcontractor_status_name).to(:rejected)
  end

  it 'rejecting the entry should change pudate the provider entry' do
    expect {
      subcon_entry1.reject
      subcon_entry1.matching_entry.reload
    }.to change(subcon_entry1.matching_entry, :status_name).to(:rejected)
  end

  it 'rejecting the entry should change the subcontractor balance' do
    expect {
      subcon_entry1.reject
      job.reload
    }.to change(job, :subcon_balance).by(subcon_entry1.amount)
  end


  context 'when the subcon rejects and then settles the remainder' do
    before do
      subcon_entry1.reject!
    end

    context 'before the job is done' do
      before do
        subcon_job.reload
        with_user(subcon_admin) do
          settle_with_provider subcon_job, amount: 100, type: 'cash'
        end
        job.reload
      end

      it 'status should remain :claim_p_settled' do
        expect(job.subcontractor_status_name).to eq :claim_p_settled
      end

      context 'when the job is completed' do
        before do
          start_the_job subcon_job
          add_bom_to_job subcon_job, cost: 10, price: 100, buyer: subcon, quantity: 1
          complete_the_work subcon_job
          job.reload
        end

        it 'subcon status should remain claim_p_settled' do
          expect(job.subcontractor_status_name).to eq :claim_p_settled
        end

      end

    end
  end

  context 'when rejecting and then paying the subcon again' do
    before do
      subcon_entry1.reject!
      job.reload
      settle_with_subcon job, amount: 10, type: 'cheque'
      job.reload
    end

    it 'should change the subcontractor status to claim_p_settled' do
      expect(job.subcontractor_status_name).to eq :claim_p_settled
    end
  end


  context 'when the cheque is rejected' do

    it 'rejecting the cheque should change the status to rejected' do
      expect {
        subcon_entry1.reject!
        job.reload
      }.to change(job.reload, :subcontractor_status_name).from(:partially_settled).to(:rejected)
    end

    it 'rejecting the cheque should reverse the balance' do
      expect {
        subcon_entry1.reject!
        job.reload
      }.to change(job, :subcon_balance).by(subcon_entry1.amount)
    end

  end

  context 'when settling again and rejecting' do
    before do
      settle_with_subcon job, amount: 20, type: 'credit_card'
      job.reload
      subcon_entry2.confirm!
      subcon_entry2.deposit!
      subcon_entry2.reject!
    end
    context 'when the check is cleared' do
      before do
        subcon_entry1.clear!
      end

      it 'the subcon status should remain partially_settled' do
        expect(job.reload.subcontractor_status_name).to eq :rejected
      end

    end
  end


  context 'when competing the job and then rejecting the first payment' do
    before do
      start_the_job subcon_job
      add_bom_to_job subcon_job, cost: 10, price: 100, buyer: subcon, quantity: 1
      complete_the_work subcon_job
      subcon_entry1.reject!
      job.reload
    end

    it 'should have a balance of 100 (as the bom reimbursement was already paid)' do
      expect(job.subcon_balance).to eq Money.new(-11000)
    end

    context 'when settling for the full amount' do
      before do
        settle_with_subcon job, amount: 110, type: 'credit_card'
      end

      it 'should change the status as claim_settled' do
        expect(job.subcontractor_status_name).to eq :claim_settled
      end

    end
  end

  context 'before completing the work' do
    context 'when the provider pays the subcon the reminder' do
      before do
        settle_with_subcon job, amount: 100, type: 'credit_card'
        subcon_entry2.confirm!
        subcon_entry2.deposit!
        subcon_entry2.reject!

        job.reload
      end

      it 'subcon status should be rejected' do
        expect(job.subcontractor_status_name).to eq :rejected
      end

      context 'when competing the work' do
        before do
          start_the_job subcon_job
          add_bom_to_job subcon_job, cost: 10, price: 100, buyer: subcon, quantity: 1
          subcon_job.reload
          complete_the_work subcon_job
          job.reload
        end

        it 'subcon status should remain to rejected' do
          expect(job.subcontractor_status_name).to eq :rejected
        end

      end


    end
  end

end