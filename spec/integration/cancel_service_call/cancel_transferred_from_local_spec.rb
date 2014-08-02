require 'spec_helper'

describe 'Cancel Job Transferred From Local' do

  include_context 'job transferred from a local provider' do
    let(:collection_allowed?) { true }
    let(:transfer_allowed?) { true }
  end

  before do
    provider.save!
    accept_the_job job
  end

  context 'when canceling the job before starting it' do
    before do
      cancel_the_job job
    end

    it 'status should be :canceled' do
      expect(job.status_name).to eq :canceled
    end

  end

  describe 'when canceling after starting the job and adding a bom' do
    before do
      start_the_job job
      add_bom_to_job job, cost: 100, price: 1000, quantity: 1, buyer: org
      cancel_the_job job
    end

    it 'status should be :canceled' do
      expect(job.status_name).to eq :canceled
    end

  end

  describe 'when canceling after adding a bom and completing the work' do
    before do
      start_the_job job
      add_bom_to_job job, cost: 100, price: 1000, quantity: 1, buyer: org
      complete_the_work job
    end

    it 'balance with the prov should be 200 (part reimbursement + work fee)' do
      expect(job.organization.account_for(job.provider.becomes(Organization)).balance).to eq Money.new(20000)
    end

    context 'when canceling' do
      before do
        cancel_the_job job
      end

      it 'status should be :canceled' do
        expect(job.status_name).to eq :canceled
      end


      it 'balance with the prov should be 200 (part reimbursement + work fee)' do
        expect(job.organization.account_for(job.provider.becomes(Organization)).balance).to eq Money.new(0)
      end

    end


  end

  describe 'when canceling after collection, adding a bom and completing the work' do
    before do
      start_the_job job
      add_bom_to_job job, cost: 100, price: 1000, quantity: 1, buyer: org
      complete_the_work job
      collect_a_payment job, amount: 100, type: 'cash', collector: org
    end

    it 'balance with the prov should be 200 (part reimbursement + work fee - collection - collection fee)' do
      expect(job.organization.account_for(job.provider.becomes(Organization)).balance).to eq Money.new(9900)
    end

    context 'when canceling' do
      before do
        cancel_the_job job
        job.reload
      end

      it 'status should be :canceled' do
        expect(job.status_name).to eq :canceled
      end


      it 'balance with the prov should be -100 (only collection)' do
        expect(job.organization.account_for(job.provider.becomes(Organization)).balance).to eq Money.new(-10000)
      end

      it 'my profit should be -100 (the lost over the part)' do
        expect(job.my_profit).to eq Money.new(-10000)
      end

    end


  end

end