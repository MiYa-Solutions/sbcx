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
    subcon_job.reload
  end

  it 'rejecting the entry should change the status' do
    expect {
      subcon_entry1.reject
      subcon_job.reload
    }.to change(subcon_job, :provider_status_name).to(:rejected)
  end

  it 'rejecting the entry should change the provider balance' do
    expect {
      subcon_entry1.reject
      subcon_job.reload
    }.to change(subcon_job, :provider_balance).by(-subcon_entry1.amount)
  end

  it 'provider entry is set to deposited' do
    expect(subcon_entry1.matching_entry.reload.status_name).to eq :deposited
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
        subcon_job.reload
      end

      it 'status should change to :partially_settled' do
        expect(subcon_job.provider_status_name).to eq :partially_settled
      end

      context 'when the job is completed' do
        before do
          start_the_job subcon_job
          add_bom_to_job subcon_job, cost: 10, price: 100, buyer: subcon, quantity: 1
          complete_the_work subcon_job
          subcon_job.reload
        end

        it 'subcon status should remain partially_settled' do
          expect(subcon_job.provider_status_name).to eq :partially_settled
        end

      end

    end
  end

  context 'when rejecting and then paying the subcon again' do
    before do
      subcon_entry1.reject!
      job.reload
      settle_with_subcon job, amount: 10, type: 'cheque'
      subcon_job.reload
    end

    it 'should change the provider status to claimed_p_settled' do
      expect(subcon_job.provider_status_name).to eq :claimed_p_settled
    end
  end

  context 'when the cheque is rejected' do

    it 'rejecting the cheque should change the status to rejected' do
      expect {
        subcon_entry1.reject!
        subcon_job.reload
      }.to change(subcon_job, :provider_status_name).from(:partially_settled).to(:rejected)
    end

  end

  context 'when settling again and rejecting' do
    before do
      settle_with_subcon job, amount: 20, type: 'cheque'
      subcon_job.reload
      subcon_entry2.confirm!
      subcon_entry2.deposit!
      subcon_entry2.reject!
    end
    context 'when the check is cleared' do
      before do
        subcon_entry1.clear!
      end

      it 'the subcon status should remain rejected' do
        expect(subcon_job.reload.provider_status_name).to eq :rejected
      end

      it 'provider entry should be cleared as well' do
        expect(subcon_entry2.matching_entry.reload.status_name).to eq :rejected
      end

    end
  end


  context 'when competing the job and then rejecting the first payment' do
    before do
      start_the_job subcon_job
      add_bom_to_job subcon_job, cost: 10, price: 100, buyer: subcon, quantity: 1
      complete_the_work subcon_job
      subcon_entry1.reject!
      subcon_job.reload
    end

    it 'should have a balance of 110 (as the bom reimbursement was already paid)' do
      expect(subcon_job.provider_balance).to eq Money.new(11000)
    end

    context 'when settling for the full amount' do
      before do
        settle_with_subcon job, amount: 110, type: 'credit_card'
        subcon_job.reload
      end

      it 'should change the status as claimed_as_settled' do
        expect(subcon_job.provider_status_name).to eq :claimed_as_settled
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

        subcon_job.reload
      end

      it 'provider status should be rejected' do
        expect(subcon_job.provider_status_name).to eq :rejected
      end

      context 'when competing the work' do
        before do
          start_the_job subcon_job
          add_bom_to_job subcon_job, cost: 10, price: 100, buyer: subcon, quantity: 1
          subcon_job.reload
          complete_the_work subcon_job
          subcon_job.reload
        end

        it 'provider status should remain to rejected' do
          expect(subcon_job.provider_status_name).to eq :rejected
        end

      end


    end
  end

end