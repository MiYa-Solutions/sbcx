require 'spec_helper'

describe 'Local Provider Settlement: When partially_settled' do

  include_context 'job transferred from a local provider' do
    let(:collection_allowed?) { true }
    let(:transfer_allowed?) { true }
  end
  let(:entry1) { job.entries.where(type: AffiliateSettlementEntry.descendants.map(&:name)).order('id asc').first }
  let(:entry2) { job.entries.where(type: AffiliateSettlementEntry.descendants.map(&:name)).order('id asc').last }

  before do
    accept_the_job job
    settle_with_provider job, amount: 10, type: 'cheque'
    entry1.confirm!
    job.reload
  end

  it 'the provider status to partially_settled' do
    expect(job.reload.provider_status_name).to eq :partially_settled
  end

  context 'when the subcon settles the remainder' do

    context 'before the job is done' do
      before do
        settle_with_provider job, amount: 100, type: 'cash'
        job.reload
      end

      it 'status should remain :partially_settled' do
        expect(job.reload.provider_status_name).to eq :partially_settled
      end

      context 'when the job is completed' do
        before do
          start_the_job job
          add_bom_to_job job, cost: 10, price: 100, quantity: 1
          complete_the_work job
          job.reload
        end

        it 'provider status should change to settled' do
          expect(job.provider_status_name).to eq :settled
        end

      end

    end
  end

  context 'when paying the subcon again' do
    before do
      job.reload
      settle_with_provider job, amount: 10, type: 'cheque'
      job.reload
    end

    it 'should change the subcontractor status to partially_settled' do
      expect(job.provider_status_name).to eq :partially_settled
    end
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
        }.to change(job.reload, :provider_status_name).from(:partially_settled).to(:rejected)
      end

      it 'rejecting the cheque should reverse the balance' do
        expect {
          entry1.reject!
          job.reload
        }.to change(job, :provider_balance).by(-entry1.amount)
      end

    end

    context 'when the check is cleared' do
      before do
        entry1.clear!
      end

      it 'the provider status should remain partially_settled' do
        expect(job.reload.provider_status_name).to eq :partially_settled
      end

    end
  end


  context 'when competing the job' do
    before do
      start_the_job job
      add_bom_to_job job, cost: 10, price: 100, quantity: 1
      complete_the_work job
      job.reload
    end

    it 'should have a balance of 100 (as the bom reimbursement was already paid)' do
      expect(job.provider_balance).to eq Money.new(10000)
    end

    context 'when settling for the remaining amount' do
      before do
        settle_with_provider job, amount: 100, type: 'credit_card'
        job.reload
      end

      it 'should change the status as settled' do
        expect(job.provider_status_name).to eq :settled
      end

    end
  end

  context 'before completing the work' do
    context 'when the provider pays the subcon the reminder' do
      before do
        settle_with_provider job, amount: 100, type: 'credit_card'
        entry2.confirm!
        job.reload
      end

      it 'provider status should remain partially_settled' do
        expect(job.provider_status_name).to eq :partially_settled
      end

      context 'when competing the work' do
        before do
          start_the_job job
          add_bom_to_job job, cost: 10, price: 100, quantity: 1
          job.reload
          complete_the_work job
          job.reload
        end

        it 'provider status should change to settled' do
          expect(job.provider_status_name).to eq :settled
        end

      end


    end
  end

end