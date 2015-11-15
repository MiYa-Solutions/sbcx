require 'spec_helper'

describe 'Local Subcon Settlement: When Pending' do

  include_context 'job transferred to local subcon'

  before do
    transfer_the_job
  end

  it 'subcon status should be pending' do
    expect(job.reload.subcontractor_status_name).to eq :pending
  end

  context 'before the job is accepted' do
    it 'should not allow settlement between the parties' do
      expect(job.reload.subcontractor_status_events).to_not include :settle
    end
  end

  context 'after the job is accepted' do
    before do
      accept_on_behalf_of_subcon job
      job.reload
    end
    it 'should allow settlement between the parties' do
      expect(job.subcontractor_status_events).to include :settle
    end

    context 'when the provider pays the subcon in advance' do
      before do
        job.reload
        settle_with_subcon job, amount: 10, type: 'cheque'
        job.reload
      end

      it 'should change the subcontractor status to partially_settled' do
        expect(job.subcontractor_status_name).to eq :partially_settled
      end

      it 'subcon account balance for prov should be 10' do
        expect(job.subcon_balance).to eq Money.new(1000)
      end


      context 'when completing the work' do
        before do
          start_the_job job
          add_bom_to_job job, cost: 10, quantity: 1, price: 100, buyer: subcon
          complete_the_work job
          job.reload
        end

        it 'subcon account balance for prov should be 10' do
          expect(job.subcon_balance).to eq Money.new(-10000)
        end


      end


    end

    context 'when completing the work' do
      before do
        start_the_job job
        add_bom_to_job job, cost: 10, price: 100, quantity: 1, buyer: subcon
        complete_the_work job
        job.reload
      end

      it 'subcon charge is 110' do
        expect(job.subcon_charge).to eq Money.new(11000)
      end


      context 'when the provider initiates the settlement for partial amount' do
        before do
          settle_with_subcon job, amount: 50
        end

        it 'should change the subcon status to partially_settled' do
          expect(job.subcontractor_status_name).to eq :partially_settled
        end
      end

      context 'when the provider initiates the settlement for the full amount' do
        before do
          settle_with_subcon job, type: 'cash', amount: 110
          job.reload
        end

        it 'should change the subcon status to settled' do
          expect(job.subcontractor_status_name).to eq :settled
        end

        it 'subcon account balance for prov should be 0' do
          expect(job.subcon_balance).to eq Money.new(0)
        end


      end

      context 'when reopenning the job' do
        before do
          reopen_the_job job
        end

        it 'provider balance is 0' do
          expect(job.subcon_balance).to eq Money.new(0)
        end

        it 'subcon charge is 0' do
          expect(job.subcon_charge).to eq Money.new(0)
        end

        context 'when completing the work (again)' do
          before do
            complete_the_work job
          end
          it 'subcon charge  is 110' do
            expect(job.subcon_charge).to eq Money.new(11000)
          end

          it 'subcon balance is -110' do
            expect(job.subcon_balance).to eq Money.new(-11000)
          end

          context 'when the provider initiates the settlement for the full amount' do
            before do
              settle_with_subcon job, type: 'cash', amount: 110
            end

            it 'should change the provider status to settled' do
              expect(job.subcontractor_status_name).to eq :settled
            end

            it 'subcon account balance for prov should be 0' do
              expect(job.subcon_balance).to eq Money.new(0)
            end


          end


        end
      end


    end

  end


end