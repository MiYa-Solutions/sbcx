require_relative '../../../../spec_helper'

describe 'Subcon Collection Status After Subcon Starts' do

  include_context 'transferred job'

  before do
    transfer_the_job
    accept_the_job subcon_job
    start_the_job subcon_job
    add_bom_to_job subcon_job, cost: '100', price: '1000', quantity: '1'
  end


  context 'before the job is done' do

    context 'subcon collects cash for the full amount' do
      before do
        collect_a_payment subcon_job, amount: '1000', type: 'cash', collector: job.subcontractor
        job.reload
        subcon_job.reload
      end

      it 'billing status should be partially_collected' do
        expect(job.billing_status_name).to eq :partially_collected
      end

      it 'subcon collection status should be partially_collected' do
        expect(job.subcon_collection_status_name).to eq :partially_collected
      end

      it 'prov collection status should be partially_collected' do
        expect(subcon_job.prov_collection_status_name).to eq :partially_collected
      end


      context 'when completing the job (and invoking the payment)' do
        before do
          complete_the_work subcon_job
        end

        it 'billing status should be collected' do
          expect(job.reload.billing_status_name).to eq :collected
        end

        it 'subcon collection status should be collected' do
          expect(job.reload.subcon_collection_status_name).to eq :collected
        end

        it 'prov collection status should be collected' do
          expect(subcon_job.reload.prov_collection_status_name).to eq :collected
        end


      end
    end

  end


end