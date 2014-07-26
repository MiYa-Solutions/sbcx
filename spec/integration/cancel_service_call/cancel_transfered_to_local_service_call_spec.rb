require 'spec_helper'

describe 'Cancel Job Transferred To Local' do
  include_context 'job transferred to local subcon'

  before do
    transfer_the_job
    accept_on_behalf_of_subcon(job)
  end


  describe 'before work starts' do
    before do
      cancel_the_job job
    end

    it 'status should be changed to canceled' do
      expect(job.status_name).to eq :canceled
    end
  end

  describe 'after the work starts and boms were added' do
    before do
      job.start_work!
      add_bom_to_job job, cost: 100, price: 1000, quantity: 1, buyer: subcon
      cancel_the_job job
    end

    it 'status should be changed to canceled' do
      expect(job.status_name).to eq :canceled
    end

    it 'prov profit should show no lost' do
      expect(job.my_profit).to eq Money.new(0)
    end

    it 'subcon balance should be zero' do
      expect(job.organization.account_for(subcon).balance).to eq Money.new(0)
    end
  end

  describe 'after the work is completed and the customer is charged' do
    before do
      start_the_job job
      add_bom_to_job job, cost: 100, price: 1000, quantity: 1, buyer: subcon
      complete_the_work job
      cancel_the_job job
    end

    it 'status should be changed to canceled' do
      expect(job.status_name).to eq :canceled
    end

    it 'the customer should be reimbursed' do
      expect(job.customer.account.balance).to eq Money.new(0)
    end

    it 'the customer should be reimbursed' do
      expect(job.entries.where(type: 'CanceledJobAdjustment').sum(:amount_cents)).to eq -100000
    end

    it 'subcon balance should be -100.00 (reimbursement for the part)' do
      expect(job.organization.account_for(subcon).balance).to eq Money.new(-10000)
    end

  end

  describe 'when a payment was collected by the subcon and job not started' do
    before do
      collect_a_payment job, amount: 100, type: 'cash', collector: subcon
      cancel_the_job job
    end

    it 'status should be changed to canceled' do
      expect(job.status_name).to eq :canceled
    end

    it 'billing status should be over paid' do
      expect(job.billing_status_name).to eq :overpaid
    end

    it 'subcon balance should be 100.00 ' do
      expect(job.organization.account_for(subcon).balance).to eq Money.new(10000)
    end
  end

  describe 'when a payment was fully collected by the subcon and job completed' do
    before do
      collect_a_payment job, amount: 100, type: 'cash', collector: subcon
      start_the_job job
      add_bom_to_job job, cost: 200, price: 1000, quantity: 1, buyer: subcon
      collect_a_payment job, amount: 100, type: 'cheque', collector: org
      complete_the_work job
      cancel_the_job job
    end

    it 'status should be changed to canceled' do
      expect(job.status_name).to eq :canceled
    end

    it 'billing status should be over paid' do
      expect(job.billing_status_name).to eq :overpaid
    end

    it 'subcon balance should be -100.00 (reimbursement for the part - collection)' do
      expect(job.organization.account_for(subcon).balance).to eq Money.new(-10000)
    end


    context 'when reimbursing the customer' do
      before do
        job.reimburse_payment!
      end

      it 'status should changed to reimbursed' do
        expect(job.billing_status_name).to eq :reimbursed
      end
    end
  end

  describe 'when a payment was partially collected by subcon and job completed' do
    before do
      collect_a_payment job, amount: 200, type: 'cash', collector: subcon
      start_the_job job
      add_bom_to_job job, cost: 100, price: 1000, quantity: 1, buyer: subcon
      complete_the_work job
      cancel_the_job job
    end

    it 'status should be changed to canceled' do
      expect(job.status_name).to eq :canceled
    end

    it 'billing status should be over paid' do
      expect(job.billing_status_name).to eq :overpaid
    end

    it 'subcon balance should be -100.00 (reimbursement for the part - collection)' do
      expect(job.organization.account_for(subcon).balance).to eq Money.new(-10000)
    end


    context 'when reimbursing the customer' do
      before do
        job.reimburse_payment!
      end

      it 'status should changed to reimbursed' do
        expect(job.billing_status_name).to eq :reimbursed
      end
    end

  end

end
