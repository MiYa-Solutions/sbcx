require 'spec_helper'

describe 'Billing when in process state' do

  include_context 'transferred job'

  before do
    transfer_the_job
    accept_the_job subcon_job
    start_the_job subcon_job
    add_bom_to_job subcon_job, cost: 100, price: 1000, quantity: 1
    collect_a_payment subcon_job, type: 'cash', amount: 1100
    complete_the_work subcon_job
    job.payments.sort.last.deposit!
  end

  it 'billing events should be :reimburse' do
    expect(job.reload.billing_status_events.sort).to eq [:reimburse]
  end

  it 'customer balance should be -100' do
    expect(job.reload.customer.account.balance).to eq Money.new(-10000)
  end

  describe 'reimbursement' do
    before do
      job.reload.reimburse_payment!
    end
    it 'billing status should be paid' do
      expect(job.billing_status_name).to eq :paid
    end

    it 'customer balance should be flat' do
      expect(job.customer.account.balance).to eq Money.new(0)
    end

    it 'reimbursement entry created with a cleared status' do
      expect(job.entries.last.status_name).to eq :cleared
    end

  end

end