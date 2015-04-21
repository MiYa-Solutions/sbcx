require 'spec_helper'


describe 'Customer Billing When In paid state' do

  include_context 'transferred job'

  before do
    transfer_the_job
    accept_the_job subcon_job
    start_the_job subcon_job
    add_bom_to_job subcon_job, cost: 100, price: 1000, quantity: 1
    complete_the_work subcon_job
    job.reload
    collect_a_payment job, type: 'cash', amount: 1000
    deposit_all_entries job.payments
    job.reload
  end

  it 'billing status should be paid' do
    expect(job.billing_status_name).to eq :paid
  end


  it 'there should be no user billing events' do
    expect(job.billing_status_events).to_not include :collect
    expect(job.billing_status_events).to_not include :late
  end


end