require 'spec_helper'

describe 'Brokered Job when Collection Deposited' do

  include_context 'brokered job'

  before do
    accept_the_job subcon_job
    start_the_job subcon_job
    add_bom_to_job subcon_job, cost: 100, price: 1000, quantity: 1
    complete_the_work subcon_job
  end

  context 'when in deposited state' do
    context 'when provider collects partially' do
      before do
        job.reload
        collect_a_payment job, amount: 250, type: 'cash'
        subcon_job.reload
        broker_job.reload
        job.reload
        collect_a_payment subcon_job, amount: 250, type: 'cash'
        subcon_job.collection_entries.last.deposit!
        broker_job.collection_entries.last.deposit!
        confirm_all_deposits job.deposited_entries
        confirm_all_deposits broker_job.deposited_entries
        subcon_job.reload
        broker_job.reload
        job.reload
      end

      it 'job subcon collection status should be deposited' do
        expect(job.subcon_collection_status_name).to eq :deposited
      end

      it 'broker_job subcon collection status should be deposited' do
        expect(job.subcon_collection_status_name).to eq :deposited
      end
      
      context 'when the subcon collects another partial amount' do
        before do
          collect_a_payment subcon_job, amount: 250, type: 'cash'
          job.reload
          broker_job.reload
          subcon_job.reload
        end
        
        it 'job subcon collection status should be partially_collected' do
          expect(job.subcon_collection_status_name).to eq :partially_collected
        end

        it 'broker subcon collection status should be partially_collected' do
          expect(broker_job.subcon_collection_status_name).to eq :partially_collected
        end

        it 'broker provider collection status should be partially_collected' do
          expect(broker_job.prov_collection_status_name).to eq :partially_collected
        end

        it 'subcon job provider collection status should be partially_collected' do
          expect(subcon_job.prov_collection_status_name).to eq :partially_collected
        end

      end

      context 'when the broker collects the full amount' do
        before do
          collect_full_amount broker_job
          job.reload
          broker_job.reload
          subcon_job.reload
        end

        it 'job subcon collection status should be collected' do
          expect(job.subcon_collection_status_name).to eq :collected
        end

        it 'broker subcon collection status should be deposited' do
          expect(broker_job.subcon_collection_status_name).to eq :deposited
        end

        it 'broker provider collection status should be collected' do
          expect(broker_job.prov_collection_status_name).to eq :collected
        end

        it 'subcon job provider collection status should be deposited' do
          expect(subcon_job.prov_collection_status_name).to eq :deposited
        end

      end



    end
  end

end