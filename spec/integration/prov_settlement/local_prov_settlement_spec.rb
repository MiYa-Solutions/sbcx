require 'spec_helper'

describe 'Local Prov Settlement' do
  include_context 'job transferred from a local provider'

  context 'when pending' do
    before do

      user.save!
      accept_the_job job
      job.update_attributes(properties: { 'provider_fee' => '100', 'prov_bom_reimbursement' => 'true' })
      start_the_job job
      add_bom_to_job job, buyer: job.organization, price: 100, cost: 10, quantity: 1
      complete_the_work job
    end

    it 'provider status should be pending' do
      expect(job.provider_status_name).to eq :pending
    end
    it 'subcon status events should be settle' do
      expect(job.provider_status_events).to eq [:settle]
    end

    it 'subcon account balance for prov should be 110.00 (subcon fee +  bom reimbursement)' do
      expect(org.account_for(job.provider.becomes(Organization)).balance).to eq Money.new(10000 + 1000)
    end


    context 'when settling' do

      context 'when settling with cash' do
        before do
          job.provider_payment = 'cash'
          job.settle_provider!
        end

        it 'subcon status should be cleared' do
          expect(job.provider_status_name).to eq :cleared
        end

        it 'subcon status events should be clear / reject' do
          expect(job.subcontractor_status_events).to eq []
        end

        it 'subcon account balance for prov should be 0.00 ' do
          expect(org.account_for(job.provider.becomes(Organization)).balance).to eq Money.new(0)
        end

      end

      context 'when settling with cheque' do
        before do
          job.provider_payment = 'cheque'
          job.settle_provider!
        end

        it 'subcon status should be settled' do
          expect(job.provider_status_name).to eq :settled
        end

        it 'subcon status events should be clear' do
          expect(job.provider_status_events).to eq [:clear]
        end
      end

    end

    context 'when subcon collects a payment' do
      before do
        collect_a_payment job, amount: 10, type: 'cash', collector: job.organization
        job.reload
      end

      it 'subcon account balance for prov should be the subcon fee - the collected amount (10) - collection fee - bom reimbur' do
        expect(org.account_for(job.provider.becomes(Organization)).balance).to eq Money.new(10000 - 1000 - 10 + 1000)
      end

      it 'should not be allowed to settle with the subcon' do
        expect(job.subcontractor_status_events).to eq []
      end

      context 'when subcon deposits the payment' do
        before do
          job.collection_entries.last.deposit!
          job.reload

        end

        it 'should be allowed to settle with the subcon' do
          expect(job.provider_status_events).to eq [:settle]
        end


        context 'when settling with the provider' do

          before do
            job.provider_payment = 'cash'
            job.settle_provider!
          end

          it 'subcon account balance for prov should be just the collected amount (0)' do
            expect(org.account_for(job.provider.becomes(Organization)).balance).to eq Money.new(0)
          end

          it 'subcon status should be cleared' do
            expect(job.provider_status_name).to eq :cleared
          end

          it 'the available collectors should be empty' do
            expect(job.available_payment_collectors).to eq []
          end

          it 'the collection should not be allowed anymore' do
            expect(job.collection_allowed?).to be false
          end

        end

      end


    end
  end
end