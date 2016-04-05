require 'spec_helper'

describe 'Local Provider Settlement: When disputed' do

  include_context 'job transferred from a local provider' do
    let(:collection_allowed?) { true }
    let(:transfer_allowed?) { true }
  end
  let(:entry1) { job.entries.where(type: AffiliateSettlementEntry.descendants.map(&:name)).order('id asc').first }
  let(:entry2) { job.entries.where(type: AffiliateSettlementEntry.descendants.map(&:name)).order('id asc').last }

  before do
    provider.save!
    accept_the_job job
    start_the_job job
    add_bom_to_job job, cost: 10, price: 100, quantity: 1
  end

  context 'after completing the work' do
    before do
      complete_the_work job
    end

    context 'when fully settled' do
      before do
        settle_with_provider job, amount: 110, type: 'cheque'
      end

      context 'when disputing' do
        before do
          entry1.dispute!
          job.reload
        end

        it 'provider status changes to disputed' do
          expect(job.provider_status_name).to eq :disputed
        end

        context 'when confirming the cheque' do
          before do
            entry1.confirm!
            job.reload
          end

          it 'provider status changes to settled' do
            expect(job.provider_status_name).to eq :settled
          end


        end
      end

    end

    context 'when fully settled with two payments' do

      before do
        job.reload
        settle_with_provider job, type: 'cash', amount: 50
        job.reload
        settle_with_provider job, type: 'cash', amount: 60
      end
       context 'when disputing the first payment' do
         before do
           entry1.dispute!
           job.reload
         end

         it 'should change the provider status to disputed' do
           expect(job.provider_status_name).to eq :disputed
         end

         context 'when confirming the second payment' do
           before do
             entry2.confirm!
             job.reload
           end

           it 'provider status should remain disputed' do
             expect(job.provider_status_name).to eq :disputed
           end

           context 'when confirming the first payment' do
             before do
               entry1.confirm!
               job.reload
             end
             it 'provider status should remain disputed' do
               expect(job.provider_status_name).to eq :settled
             end
           end

         end
        end
    end

    context 'when partially settled with two payments' do

      before do
        settle_with_provider job, type: 'cash', amount: 30
        job.reload
        settle_with_provider job, type: 'cash', amount: 50
      end
      context 'when disputing the first payment' do
        before do
          entry1.dispute!
          job.reload
        end

        it 'should change the provider status to disputed' do
          expect(job.provider_status_name).to eq :disputed
        end

        context 'when confirming the second payment' do
          before do
            entry2.confirm!
            job.reload
          end

          it 'provider status should remain disputed' do
            expect(job.provider_status_name).to eq :disputed
          end

          context 'when confirming the first payment' do
            before do
              entry1.confirm!
              job.reload
            end
            it 'provider status should remain disputed' do
              expect(job.provider_status_name).to eq :partially_settled
            end
          end

          context 'when settling with another partial payment' do
            let(:entry3) { job.entries.where(type: AffiliateSettlementEntry.descendants.map(&:name)).order('id asc').last }

            before do
              job.reload
              settle_with_provider job, type: 'cash', amount: 10
              job.reload
            end

            it 'provider status should remain disputed' do
              expect(job.provider_status_name).to eq :disputed
            end


          end

        end
      end
    end


  end

end