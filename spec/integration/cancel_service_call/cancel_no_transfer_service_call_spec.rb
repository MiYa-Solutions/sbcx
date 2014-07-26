require 'spec_helper'

describe 'Cancel My Job - No Transfer' do
  include_context 'basic job testing'
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
      add_bom_to_job job, cost: 100, price: 1000, quantity: 1
      cancel_the_job job
    end

    it 'status should be changed to canceled' do
      expect(job.status_name).to eq :canceled
    end

    it 'my profit should show the lost' do
      expect(job.my_profit).to eq Money.new(-10000)
    end
  end

  describe 'after the work is completed and the customer is charged' do
    before do
      job.start_work!
      add_bom_to_job job, cost: 100, price: 1000, quantity: 1
      job.complete_work!
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


  end

  describe 'when a payment was collected and job not started' do
    before do
      collect_a_payment job, amount: 100, type: 'cash'
      job.payments.last.deposit!
      cancel_the_job job
    end

    it 'status should be changed to canceled' do
      expect(job.status_name).to eq :canceled
    end

    it 'billing status should be over paid' do
      expect(job.billing_status_name).to eq :overpaid
    end
  end

  describe 'when a payment was fully collected and job completed' do
    before do
      collect_a_payment job, amount: 100, type: 'cash'
      start_the_job job
      add_bom_to_job job, cost: 100, price: 1000, quantity: 1
      collect_a_payment job, amount: 100, type: 'cheque'
      complete_the_work job
      cancel_the_job job
    end

    it 'status should be changed to canceled' do
      expect(job.status_name).to eq :canceled
    end

    it 'billing status should be over paid' do
      expect(job.billing_status_name).to eq :overpaid
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

  describe 'when a payment was partially collected and job completed' do
    before do
      collect_a_payment job, amount: 100, type: 'cash'
      start_the_job job
      add_bom_to_job job, cost: 100, price: 1000, quantity: 1
      complete_the_work job
      cancel_the_job job
    end

    it 'status should be changed to canceled' do
      expect(job.status_name).to eq :canceled
    end

    it 'billing status should be over paid' do
      expect(job.billing_status_name).to eq :overpaid
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
