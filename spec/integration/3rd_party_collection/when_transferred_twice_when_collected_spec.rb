require 'spec_helper'

describe '3rd Party Collection' do

  include_context 'brokered job'

  before do
    accept_the_job subcon_job
    start_the_job subcon_job
    add_bom_to_job subcon_job, cost: 100, price: 1000, quantity: 1
    complete_the_work subcon_job
  end

  context 'when in collected state' do
    context 'when subcon collected' do
      before do
        collect_full_amount subcon_job
        subcon_job.reload
        broker_job.reload
        job.reload
      end

      it 'subcon collection status should be collected' do
        expect(job.subcon_collection_status_name).to eq :collected
      end

      it 'subcon collection status should be collected' do
        expect(broker_job.subcon_collection_status_name).to eq :collected
      end

      it 'provider collection status should be collected' do
        expect(broker_job.prov_collection_status_name).to eq :collected
      end

      it 'provider collection status should be collected' do
        expect(subcon_job.prov_collection_status_name).to eq :collected
      end

      context 'when deposited' do

        context 'when subcon deposits' do
          before do
            subcon_job.collection_entries.last.deposit!
            subcon_job.reload
            broker_job.reload
            job.reload
          end

          it 'subcon collection status should be collected' do
            expect(job.subcon_collection_status_name).to eq :collected
          end

          it 'subcon collection status should be is_deposited' do
            expect(broker_job.subcon_collection_status_name).to eq :is_deposited
          end

          it 'provider collection status should be collected' do
            expect(broker_job.prov_collection_status_name).to eq :collected
          end

          it 'provider collection status should be is_deposited' do
            expect(subcon_job.prov_collection_status_name).to eq :is_deposited
          end

          context 'when broker deposits subcon deposit entry' do
            before do
              broker_job.collection_entries.last.deposit!
              subcon_job.reload
              broker_job.reload
              job.reload
            end
            it 'subcon collection status should be is_deposited' do
              expect(job.subcon_collection_status_name).to eq :is_deposited
            end

            it 'subcon collection status should be is_deposited' do
              expect(broker_job.subcon_collection_status_name).to eq :is_deposited
            end

            it 'provider collection status should be is_deposited' do
              expect(broker_job.prov_collection_status_name).to eq :is_deposited
            end

            it 'provider collection status should be is_deposited' do
              expect(subcon_job.prov_collection_status_name).to eq :is_deposited
            end


          end

        end
      end

    end
    pending 'when broker collected' do

    end
    pending 'when provider collected'

    pending 'when both broker and subcon collected'
  end

end