require 'spec_helper'

describe 'Member Provider Settlement: When disputed' do

  include_context 'transferred job'
  let(:subcon_entry1) { subcon_job.entries.where(type: AffiliateSettlementEntry.descendants.map(&:name)).order('id asc').first }
  let(:subcon_entry2) { subcon_job.entries.where(type: AffiliateSettlementEntry.descendants.map(&:name)).order('id asc').last }

  before do
    transfer_the_job
    accept_the_job subcon_job
    start_the_job subcon_job
    add_bom_to_job subcon_job, cost: 10, price: 100, buyer: subcon, quantity: 1
  end

  context 'after completing the work' do
    before do
      complete_the_work subcon_job
    end

    context 'when fully settled' do
      before do
        job.reload
        subcon_job.reload
        settle_with_subcon job, amount: 110, type: 'cheque'
      end

      context 'when disputing' do
        before do
          subcon_entry1.dispute!
          subcon_job.reload
        end

        it 'provider status changes to disputed' do
          expect(subcon_job.provider_status_name).to eq :disputed
        end

        context 'when confirming the cheque' do
          before do
            subcon_entry1.confirm!
            subcon_job.reload
          end

          it 'provider status changes to settled' do
            expect(subcon_job.provider_status_name).to eq :settled
          end


        end
      end

    end

    context 'when fully settled with two payments' do

      before do
        job.reload
        settle_with_subcon job, type: 'cash', amount: 50
        job.reload
        subcon_job.reload
        settle_with_subcon job, type: 'cash', amount: 60
      end
       context 'when disputing the first payment' do
         before do
           subcon_entry1.dispute!
           subcon_job.reload
         end

         it 'should change the provider status to disputed' do
           expect(subcon_job.provider_status_name).to eq :disputed
         end

         context 'when confirming the second payment' do
           before do
             job.reload
             subcon_entry2.confirm!
             subcon_job.reload
           end

           it 'provider status should remain disputed' do
             expect(subcon_job.provider_status_name).to eq :disputed
           end

           context 'when confirming the first payment' do
             before do
               job.reload
               subcon_entry1.confirm!
               subcon_job.reload
             end
             it 'provider status should remain disputed' do
               expect(subcon_job.provider_status_name).to eq :settled
             end
           end

         end
        end
    end

    context 'when partially settled with two payments' do

      before do
        job.reload
        settle_with_subcon job, type: 'cash', amount: 30
        job.reload
        settle_with_subcon job, type: 'cash', amount: 50
      end
      context 'when disputing the first payment' do
        before do
          subcon_entry1.dispute!
          subcon_job.reload
        end

        it 'should change the provider status to disputed' do
          expect(subcon_job.provider_status_name).to eq :disputed
        end

        context 'when confirming the second payment' do
          before do
            subcon_entry2.confirm!
            subcon_job.reload
          end

          it 'provider status should remain disputed' do
            expect(subcon_job.provider_status_name).to eq :disputed
          end

          context 'when confirming the first payment' do
            before do
              subcon_job.reload
              subcon_entry1.confirm!
              subcon_job.reload
            end
            it 'provider status should remain disputed' do
              expect(subcon_job.provider_status_name).to eq :partially_settled
            end
          end

          context 'when settling with another partial payment' do
            let(:subcon_entry3) { subcon_job.entries.where(type: AffiliateSettlementEntry.descendants.map(&:name)).order('id asc').last }

            before do
              subcon_job.reload
              settle_with_subcon job, type: 'cash', amount: 10
              subcon_job.reload
            end

            it 'provider status should remain disputed' do
              expect(subcon_job.provider_status_name).to eq :disputed
            end


          end

        end
      end
    end


  end

end