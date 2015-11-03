require 'spec_helper'

describe 'Local Provider Settlement: When Pending' do

  include_context 'job transferred from a local provider' do
    let(:collection_allowed?) { true }
    let(:transfer_allowed?) { true }
  end

  before do
    provider.save!
  end

  it 'subcon status should be pending' do
    expect(job.provider_status_name).to eq :pending
  end

  context 'before the job is accepted' do
    it 'should not allow settlement between the parties' do
      expect(job.provider_status_events).to_not include :settle
    end
  end

  context 'after the job is accepted' do
    before do
      accept_the_job job
    end
    it 'should allow settlement between the parties' do
      expect(job.provider_status_events).to include :settle
    end

    context 'when the provider pays the subcon in advance' do
      before do
        job.reload
        settle_with_provider job, amount: 10, type: 'cheque'
      end

      it 'should change the provider status to partially_settled' do
        expect(job.provider_status_name).to eq :partially_settled
      end

      it 'provider account balance for prov should be -10' do
        expect(job.provider_balance).to eq Money.new(-1000)
      end

      context 'when completing the work' do
        before do
          start_the_job job
          add_bom_to_job job, cost: 10, quantity: 1, price: 100
          complete_the_work job
          job.reload
        end

        it 'provider account balance for prov should be 10' do
          expect(job.provider_balance).to eq Money.new(10000)
        end


      end


    end

    context 'when completing the work' do
      before do
        start_the_job job
        add_bom_to_job job, cost: 10, price: 100, quantity: 1
        complete_the_work job
      end

      it 'provider charge is 110' do
        expect(job.provider_charge).to eq Money.new(11000)
      end


      context 'when the provider initiates the settlement for partial amount' do
        before do
          settle_with_provider job, amount: 50
          job.reload
        end

        it 'should change the subcon status to partially_settled' do
          expect(job.provider_status_name).to eq :partially_settled
        end
      end

      context 'when the provider initiates the settlement for the full amount' do
        before do
          settle_with_provider job, type: 'cash', amount: 110
        end

        it 'should change the provider status to settled' do
          expect(job.provider_status_name).to eq :settled
        end

        it 'provider account balance for prov should be 0' do
          expect(job.provider_balance).to eq Money.new(0)
        end


      end

      context 'when the subcon initiaes the settlement for the full amount' do
        before do
          settle_with_provider job, type: 'cash', amount: 110
        end

        it 'should change the subcon status to settled' do
          expect(job.provider_status_name).to eq :settled
        end

      end

      context 'when reopenning the job' do
        before do
          reopen_the_job job
        end

        it 'provider balance is 0' do
          expect(job.provider_balance).to eq Money.new(0)
        end

        it 'provider charge is 0' do
          expect(job.provider_charge).to eq Money.new(0)
        end


        context 'when completing the work (again)' do
          before do
            complete_the_work job
          end

          it 'provider balance is 110' do
            expect(job.provider_balance).to eq Money.new(11000)
          end

          it 'provider charge is 110' do
            expect(job.provider_charge).to eq Money.new(11000)
          end


          context 'when the provider initiates the settlement for the full amount' do
            before do
              settle_with_provider job, type: 'cash', amount: 110
            end

            it 'should change the provider status to settled' do
              expect(job.provider_status_name).to eq :settled
            end

            it 'provider account balance for prov should be 0' do
              expect(job.provider_balance).to eq Money.new(0)
            end

            it 'provider charge is 110' do
              expect(job.provider_charge).to eq Money.new(11000)
            end

          end


        end
      end

    end

  end


end