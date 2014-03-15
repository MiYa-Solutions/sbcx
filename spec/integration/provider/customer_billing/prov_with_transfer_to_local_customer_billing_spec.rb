require 'spec_helper'

describe 'Customer Billing When Provider Transfers To Local' do

  include_context 'job transferred to local subcon'

  before do
    transfer_the_job
    accept_on_behalf_of_subcon(job)
    start_the_job job
    add_bom_to_job job, cost: '100', price: '1000', quantity: '1', buyer: job.subcontractor
  end

  context 'before the job is done' do

    context 'subcon collects cash' do
      before do
        collect_a_payment job, amount: '1000', type: 'cash', collector: job.subcontractor
        job.reload
      end

      it 'billing status should be partially_collected' do
        expect(job.billing_status_name).to eq :partially_collected
      end
    end

  end

  context 'after the job is done' do

    before do
      before do
        complete_the_work subcon_job
      end

    end



  end
end