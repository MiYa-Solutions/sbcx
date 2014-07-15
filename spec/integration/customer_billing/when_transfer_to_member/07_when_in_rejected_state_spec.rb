require 'spec_helper'

describe 'Billing when in rejected state' do

  include_context 'transferred job'

  before do
    transfer_the_job
    accept_the_job subcon_job
    start_the_job subcon_job
    add_bom_to_job subcon_job, cost: 100, price: 1000, quantity: 1
    collect_a_payment subcon_job, type: 'amex_credit_card', amount: 1100
    complete_the_work subcon_job
    job.payments.sort.last.deposit!
    job.payments.sort.last.reject
  end

  it 'billing events should be :collect, :late' do
    expect(job.billing_status_events.sort).to eq [:collect, :late]
  end

  it 'billing status should be rejected' do
    expect(job.reload.billing_status_name).to eq :rejected
  end


  context 'when payment collected' do

    context 'when fully collected' do
      before do
        job.reload
        collect_a_payment job, type: 'cash', amount: 1000
        job.reload
      end

      it 'billing status should be collected' do
        expect(job.billing_status_name).to eq :collected
      end
    end

    context 'when partially collected' do
      before do
        job.reload
        collect_a_payment job, type: 'cash', amount: 900
        job.reload
      end

      it 'billing status should be collected' do
        expect(job.billing_status_name).to eq :partially_collected
      end
    end

  end

  context 'when payment is late' do
    before do
      job.late_payment!
    end

    it 'billing status should be overdue' do
      expect(job.billing_status_name).to eq :overdue
    end

  end

end