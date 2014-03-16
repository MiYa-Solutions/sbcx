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

      it 'subcon collection status should be partially_collected' do
        expect(job.subcon_collection_status_name).to eq :partially_collected
      end

      context 'when the job is done' do
        before do
          complete_the_work job
        end

        it 'billing status should be collected' do
          expect(job.billing_status_name).to eq :collected
        end



        context 'when depositing the collected payment at the provider' do
          before do
            job.collected_entries.last.deposited!
            job.reload
          end

          it 'billing status should be collected' do
            expect(job.reload.billing_status_name).to eq :collected
          end

          it 'subcon collection status should be is_deposited' do
            expect(job.subcon_collection_status_name).to eq :is_deposited
          end


        end

      end
    end

    context 'subcon collects cheque' do
      context 'when collecting the full amount' do
        before do
          collect_a_payment job, amount: '1000', type: 'cheque', collector: job.subcontractor
          job.reload
        end

        it 'billing status should be partially_collected' do
          expect(job.billing_status_name).to eq :partially_collected
        end

        it 'subcon collection status should be partially_collected' do
          expect(job.subcon_collection_status_name).to eq :partially_collected
        end

        context 'when completing the work' do
          before do
            complete_the_work job
          end

          it 'billing status should be collected' do
            expect(job.billing_status_name).to eq :collected
          end

          it 'subcon collection status should be collected' do
            expect(job.subcon_collection_status_name).to eq :collected
          end

          context 'when depositing '


        end

      end

      context 'when collecting the partial amount' do

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