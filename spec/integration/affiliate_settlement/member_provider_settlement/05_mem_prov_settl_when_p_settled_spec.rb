require 'spec_helper'

describe 'Member Provider Settlement: When partially_settled' do

  include_context 'transferred job'
  let(:subcon_entry1) { subcon_job.entries.order('id asc').first }
  let(:subcon_entry2) { subcon_job.entries.order('id asc').last }

  before do
    transfer_the_job
    accept_the_job subcon_job
    job.reload
    settle_with_subcon job, amount: 10, type: 'cheque'
    subcon_entry1.confirm!
    job.reload
  end

  it 'the provider status to partially_settled' do
    expect(subcon_job.reload.provider_status_name).to eq :partially_settled
  end

  context 'when the subcon settles the remainder' do

    context 'before the job is done' do
      before do
        subcon_job.reload
        with_user(subcon_admin) do
          settle_with_provider subcon_job, amount: 100, type: 'cash'
        end
        job.reload
      end

      it 'status should remain :partially_settled' do
        expect(subcon_job.reload.provider_status_name).to eq :partially_settled
      end

      context 'when the job is completed' do
        before do
          start_the_job subcon_job
          add_bom_to_job subcon_job, cost: 10, price: 100, buyer: subcon, quantity: 1
          complete_the_work subcon_job
          subcon_job.reload
        end

        it 'provider status should change to settled' do
          expect(subcon_job.provider_status_name).to eq :settled
        end

      end

    end
  end

  context 'when paying the subcon again' do
    before do
      subcon_job.reload
      settle_with_subcon job, amount: 10, type: 'cheque'
      subcon_job.reload
    end

    it 'should change the subcontractor status to claimed_p_settled' do
      expect(subcon_job.provider_status_name).to eq :claimed_p_settled
    end
  end

  context 'when the cheque is deposited' do
    before do
      subcon_entry1.deposit!
    end

    context 'when the cheque is rejected' do

      it 'rejecting the cheque should change the status to rejected' do
        expect {
          subcon_entry1.reject!
          subcon_job.reload
        }.to change(subcon_job.reload, :provider_status_name).from(:partially_settled).to(:rejected)
      end

      it 'rejecting the cheque should reverse the balance' do
        expect {
          subcon_entry1.reject!
          job.reload
        }.to change(subcon_job, :provider_balance).by(-subcon_entry1.amount)
      end

    end

    context 'when the check is cleared' do
      before do
        subcon_entry1.clear!
      end

      it 'the provider status should remain partially_settled' do
        expect(subcon_job.reload.provider_status_name).to eq :partially_settled
      end

    end
  end


  context 'when competing the job' do
    before do
      start_the_job subcon_job
      add_bom_to_job subcon_job, cost: 10, price: 100, buyer: subcon, quantity: 1
      complete_the_work subcon_job
      subcon_job.reload
    end

    it 'should have a balance of 100 (as the bom reimbursement was already paid)' do
      expect(subcon_job.provider_balance).to eq Money.new(10000)
    end

    context 'when settling for the remaining amount' do
      before do
        settle_with_subcon job, amount: 100, type: 'credit_card'
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
        subcon_job.reload
      end

      it 'provider status should remain partially_settled' do
        expect(subcon_job.provider_status_name).to eq :partially_settled
      end

      context 'when competing the work' do
        before do
          start_the_job subcon_job
          add_bom_to_job subcon_job, cost: 10, price: 100, buyer: subcon, quantity: 1
          subcon_job.reload
          complete_the_work subcon_job
          subcon_job.reload
        end

        it 'provider status should change to settled' do
          expect(subcon_job.provider_status_name).to eq :settled
        end

      end


    end
  end

end