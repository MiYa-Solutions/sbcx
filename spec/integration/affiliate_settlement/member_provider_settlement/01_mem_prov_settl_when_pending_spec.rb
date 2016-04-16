require 'spec_helper'

describe 'Member Provider Settlement: When Pending' do

  include_context 'transferred job'

  before do
    transfer_the_job
  end

  it 'subcon status should be pending' do
    expect(subcon_job.provider_status_name).to eq :pending
  end

  context 'before the job is accepted' do
    it 'should not allow settlement between the parties' do
      expect(subcon_job.provider_status_events).to_not include :settle
    end
  end

  context 'after the job is accepted' do
    before do
      accept_the_job subcon_job
      job.reload
    end
    it 'should allow settlement between the parties' do
      expect(subcon_job.provider_status_events).to include :settle
    end

    context 'when the provider pays the subcon in advance' do
      before do
        job.reload
        settle_with_subcon job, amount: 10, type: 'cheque'
        subcon_job.reload
      end

      it 'should change the provider status to claimed_as_p_settled' do
        expect(subcon_job.provider_status_name).to eq :claimed_p_settled
      end

      it 'provider account balance for prov should be 10' do
        expect(subcon_job.provider_balance).to eq Money.new(-1000)
      end

      it 'job should have notification associated with it' do
        expect(subcon_job.notifications.last.type).to eq 'ScProviderSettledNotification'
      end


      context 'when completing the work' do
        before do
          start_the_job subcon_job
          add_bom_to_job subcon_job, cost: 10, quantity: 1, price: 100
          complete_the_work subcon_job
          job.reload
        end

        it 'provider account balance for prov should be 10' do
          expect(subcon_job.provider_balance).to eq Money.new(10000)
        end


      end

    end

    context 'when the provider over-pays the subcon in advance' do
      before do
        job.reload
        settle_with_subcon job, amount: 200, type: 'cheque'
        subcon_job.reload
      end

      it 'should change the provider status to claimed_as_p_settled' do
        expect(subcon_job.provider_status_name).to eq :claimed_p_settled
      end

      it 'provider account balance for prov should be 10' do
        expect(subcon_job.provider_balance).to eq Money.new(-20000)
      end

      it 'job should have notification associated with it' do
        expect(subcon_job.notifications.last.type).to eq 'ScProviderSettledNotification'
      end


      context 'when completing the work' do
        let(:subcon_entry) { subcon_job.entries.where(type: AffiliateSettlementEntry.descendants.map(&:name)).order('id asc').first }
        let(:prov_entry) { job.entries.where(type: AffiliateSettlementEntry.descendants.map(&:name)).order('id asc').last }

        before do
          subcon_entry.confirm!
          prov_entry.deposit!
          prov_entry.clear!
          start_the_job subcon_job
          add_bom_to_job subcon_job, cost: 10, quantity: 1, price: 100
          complete_the_work subcon_job
          job.reload
        end

        it 'provider account balance for prov should be 10' do
          expect(subcon_job.provider_balance).to eq Money.new(-9000)
        end

        it 'provider status to remain claimed_as_p_settled' do
          expect(subcon_job.provider_status_name).to eq :claimed_p_settled
        end

        context 'when submitting a reverse cash payment as reimbursement' do
          let(:subcon_entry2) { subcon_job.entries.where(type: AffiliateSettlementEntry.descendants.map(&:name)).order('id asc').last }
          let(:prov_entry2) { job.entries.where(type: AffiliateSettlementEntry.descendants.map(&:name)).order('id asc').last }

          before do
            settle_with_subcon job, amount: -90, type: 'cash'
            subcon_job.reload
            job.reload

            subcon_entry2.confirm!
            prov_entry2.deposit!

            subcon_job.reload
            job.reload
          end

          it 'provider status should change to cleared' do
            expect(subcon_job.provider_status_name).to eq :cleared
          end

          it 'subcon status should change to settled' do
            expect(job.subcontractor_status_name).to eq :cleared
          end


        end


        # it 'subcon_job#provider_fully_settled?? returns false' do
        #   expect(subcon_job.provider_fully_settled?).to eq true
        # end
        #
        # it 'job#subcon_fully_settled?? returns false' do
        #   expect(job.subcon_fully_settled?).to eq false
        # end



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
          subcon_job.reload
        end

        it 'should change the subcon status to claimed_p_settled' do
          expect(subcon_job.provider_status_name).to eq :claimed_p_settled
        end
      end

      context 'when the provider initiates the settlement for the full amount' do
        before do
          settle_with_subcon job, type: 'cash', amount: 110
          subcon_job.reload
        end

        it 'should change the provider status to claimed_as_settled' do
          expect(subcon_job.provider_status_name).to eq :claimed_as_settled
        end

        it 'provider account balance for prov should be 0' do
          expect(subcon_job.provider_balance).to eq Money.new(0)
        end


      end

      context 'when the subcon initiates the settlement for the full amount' do
        before do
          subcon_job.reload
          with_user(subcon_admin) do
            settle_with_provider subcon_job, type: 'cash', amount: 110
          end
          job.reload
        end

        it 'should change the subcon status to settled' do
          expect(subcon_job.provider_status_name).to eq :settled
        end

      end

    end

  end


end