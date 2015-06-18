require 'spec_helper'

describe 'Member Subcon Settlement: When Pending' do

  include_context 'transferred job'

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
      accept_the_job subcon_job
      job.reload
    end
    it 'should allow settlement between the parties' do
      expect(job.subcontractor_status_events).to include :settle
    end

    context 'when the provider pays the subcon in advance' do
      before do
        job.reload
        settle_with_subcon job, amount: 10, type: 'cheque'
      end

      it 'should change the subcontractor status to claim_as_p_settled' do
        expect(job.subcontractor_status_name).to eq :claim_p_settled
      end

      it 'subcon account balance for prov should be 10' do
        expect(job.organization.account_for(job.subcontractor.becomes(Organization)).balance).to eq Money.new(1000)
      end


      context 'when completing the work' do
        before do
          start_the_job subcon_job
          add_bom_to_job subcon_job, cost: 10, quantity: 1, price: 100
          complete_the_work subcon_job
          job.reload
        end

        it 'subcon account balance for prov should be 10' do
          expect(job.organization.account_for(job.subcontractor.becomes(Organization)).balance).to eq Money.new(-10000)
        end


      end


    end

    context 'when completing the work' do
      before do
        start_the_job subcon_job
        add_bom_to_job subcon_job, cost: 10, price: 100, quantity: 1
        complete_the_work subcon_job
        job.reload
      end

      context 'when the provider initiates the settlement for partial amount' do
        before do
          settle_with_subcon job, amount: 50
        end

        it 'should change the subcon status to claim_p_settled' do
          expect(job.subcontractor_status_name).to eq :claim_p_settled
        end
      end

      context 'when the provider initiates the settlement for the full amount' do
        before do
          settle_with_subcon job, type: 'cash', amount: 110
        end

        it 'should change the subcon status to claim_settled' do
          expect(job.subcontractor_status_name).to eq :claim_settled
        end

        it 'subcon account balance for prov should be 0' do
          expect(job.organization.account_for(job.subcontractor.becomes(Organization)).balance).to eq Money.new(0)
        end


      end

      context 'when the subcon initiaes the settlement for the full amount' do
        before do
          subcon_job.reload
          with_user(subcon_admin) do
            settle_with_provider subcon_job, type: 'cash', amount: 110
          end
          job.reload
        end

        it 'should change the subcon status to settled' do
          expect(job.subcontractor_status_name).to eq :settled
        end

        it 'job should have notification associated with it' do
          expect(job.notifications.last.type).to eq 'ScSubconSettledNotification'
        end
      end

    end

  end


end