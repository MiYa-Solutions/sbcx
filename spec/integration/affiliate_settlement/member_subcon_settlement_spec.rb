require 'spec_helper'

describe 'Member Subcon Settlement' do
  include_context 'transferred job'

  context 'when NOT collecting payments (before work completion)' do

    before do
      transfer_the_job
      accept_the_job subcon_job
      start_the_job subcon_job
      add_bom_to_job subcon_job, cost: 100, price: 1000, quantity: 1
    end

    it 'provider job: subcon status should be pending' do
      expect(job.subcontractor_status_name).to eq :pending
    end

    it 'subcon job: subcon status should be pending' do
      expect(subcon_job.provider_status_name).to eq :pending
    end

    it 'provider job: subcon settlement is not allowed yet (need to complete the work first)' do
      expect(job.subcontractor_status_events).to_not include :settle
    end

    it 'subcon job: provider settlement is not allowed yet (need to complete the first)' do
      expect(subcon_job.provider_status_events).to eq []
    end

    context 'after work completion' do
      before do
        complete_the_work subcon_job
        job.reload
      end

      it 'provider job: subcon settlement is allowed' do
        expect(job.subcontractor_status_events).to include :settle
        expect(job.subcontractor_status_events).to include :subcon_marked_as_settled
        expect(event_permitted_for_job?('subcontractor_status', 'subcon_marked_as_settled', subcon_admin, subcon_job)).to be_false
        expect(event_permitted_for_job?('subcontractor_status', 'settle', subcon_admin, subcon_job)).to be_true

      end

      it 'subcon job: provider settlement is allowed ' do
        expect(subcon_job.provider_status_events).to eq [:provider_marked_as_settled, :settle]
        expect(event_permitted_for_job?('provider_status', 'provider_marked_as_settled', subcon_admin, subcon_job)).to be_false
        expect(event_permitted_for_job?('provider_status', 'settle', subcon_admin, subcon_job)).to be_true
      end

      context 'when subcon initiates the cheque settlement' do
        before do
          subcon_job.provider_payment = 'cheque'
          subcon_job.settle_provider!
          job.reload
        end

        it 'provider job: subcon status should be claimed_as_settled' do
          expect(job.subcontractor_status_name).to eq :claimed_as_settled
        end

        it 'subcon job: subcon status should be claim_settled' do
          expect(subcon_job.provider_status_name).to eq :claim_settled
        end

        it 'provider job: is able to confirm settlement' do
          expect(job.subcontractor_status_events).to eq [:confirm_settled]
          expect(event_permitted_for_job?('subcontractor_status', 'confirm_settled', subcon_admin, subcon_job)).to be_true
        end

        it 'subcon job: not allowed to mark the job as settlement confirmed' do
          expect(subcon_job.provider_status_events).to eq [:provider_confirmed]
          expect(event_permitted_for_job?('provider_status', 'provider_confirmed', subcon_admin, subcon_job)).to be_false
        end

        it 'subcon account balance for prov should be: zero' do
          expect(job.organization.account_for(job.subcontractor.becomes(Organization)).balance).to eq Money.new(0)
        end

        it 'prov account balance for prov should be: zero' do
          expect(subcon_job.organization.account_for(job.provider.becomes(Organization)).balance).to eq Money.new(0)
        end

        context 'when provider confirms settlement' do
          before do
            job.confirm_settled_subcon!
            subcon_job.reload
          end

          it 'provider job: subcon status should be settled' do
            expect(job.subcontractor_status_name).to eq :settled
          end

          it 'subcon job: subcon status should be settled' do
            expect(subcon_job.provider_status_name).to eq :settled
          end

          it 'provider job: subcon settlement clearing is not allowed for a user' do
            expect(job.subcontractor_status_events).to eq [:clear]
            expect(event_permitted_for_job?('subcontractor_status', 'clear', subcon_admin, subcon_job)).to be_false
          end

          it 'subcon job: provider settlement is allowed' do
            expect(subcon_job.provider_status_events).to eq [:clear]
            expect(event_permitted_for_job?('provider_status', 'clear', subcon_admin, subcon_job)).to be_true
          end

          it 'subcon account balance for prov should be: zero' do
            expect(job.organization.account_for(job.subcontractor.becomes(Organization)).balance).to eq Money.new(0)
          end

          it 'prov account balance for prov should be: zero' do
            expect(subcon_job.organization.account_for(job.provider.becomes(Organization)).balance).to eq Money.new(0)
          end

          context 'when subcon marks the settlement as cleared' do
            before do
              subcon_job.clear_provider!
              job.reload
            end

            it 'provider job: subcon status should be cleared' do
              expect(job.subcontractor_status_name).to eq :cleared
            end

            it 'subcon job: subcon status should be cleared' do
              expect(subcon_job.provider_status_name).to eq :cleared
            end

            it 'provider job: there are no more settlement events available' do
              expect(job.subcontractor_status_events).to eq []
            end

            it 'subcon job: there are no more settlement events available' do
              expect(subcon_job.provider_status_events).to eq []
            end

          end

        end

      end

      context 'when provider initiates the cheque settlement' do
        before do
          job.subcon_payment = 'cheque'
          job.settle_subcon!
          subcon_job.reload
        end

        it 'provider job: subcon status should be claim_settled' do
          expect(job.subcontractor_status_name).to eq :claim_settled
        end

        it 'subcon job: provider settlement status should be claimed_as_settled' do
          expect(subcon_job.provider_status_name).to eq :claimed_as_settled
        end

        it 'provider job: subcon settlement confirmation is not allowed for user' do
          expect(job.subcontractor_status_events).to eq [:subcon_confirmed]
          expect(event_permitted_for_job?('subcontractor_status', 'subcon_confirmed', subcon_admin, subcon_job)).to be_false
        end

        it 'subcon job: provider settlement confirmation is permitted for a user' do
          expect(subcon_job.provider_status_events).to eq [:confirm_settled]
          expect(event_permitted_for_job?('provider_status', 'confirm_settled', subcon_admin, subcon_job)).to be_true
        end

        it 'subcon account balance for prov should be: zero' do
          expect(job.organization.account_for(job.subcontractor.becomes(Organization)).balance).to eq Money.new(0)
        end

        it 'prov account balance for prov should be: zero' do
          expect(subcon_job.organization.account_for(job.provider.becomes(Organization)).balance).to eq Money.new(0)
        end

        context 'when subcon confirms settlement' do
          before do
            subcon_job.confirm_settled_provider!
            job.reload
          end

          it 'provider job: subcon status should be settled' do
            expect(job.subcontractor_status_name).to eq :settled
          end

          it 'subcon job: subcon status should be settled' do
            expect(subcon_job.provider_status_name).to eq :settled
          end

          it 'provider job: subcon settlement clearing is not allowed for a user' do
            expect(job.subcontractor_status_events).to eq [:clear]
            expect(event_permitted_for_job?('subcontractor_status', 'clear', subcon_admin, subcon_job)).to be_false
          end

          it 'subcon job: provider settlement clearing is allowed' do
            expect(subcon_job.provider_status_events).to eq [:clear]
            expect(event_permitted_for_job?('provider_status', 'clear', subcon_admin, subcon_job)).to be_true
          end

          it 'subcon account balance for prov should be: zero' do
            expect(job.organization.account_for(job.subcontractor.becomes(Organization)).balance).to eq Money.new(0)
          end

          it 'prov account balance for prov should be: zero' do
            expect(subcon_job.organization.account_for(job.provider.becomes(Organization)).balance).to eq Money.new(0)
          end

          context 'when subcon marks the settlement as cleared' do
            before do
              subcon_job.clear_provider!
              job.reload
            end

            it 'provider job: subcon status should be cleared' do
              expect(job.subcontractor_status_name).to eq :cleared
            end

            it 'subcon job: subcon status should be cleared' do
              expect(subcon_job.provider_status_name).to eq :cleared
            end

            it 'provider job: no subcon settlement events are left' do
              expect(job.subcontractor_status_events).to eq []
            end

            it 'subcon job: no provider settlement events are left' do
              expect(subcon_job.provider_status_events).to eq []
            end

          end

        end

      end

      context 'when subcon initiates the cash settlement' do
        before do
          subcon_job.provider_payment = 'cash'
          subcon_job.settle_provider!
          job.reload
        end

        it 'provider job: subcon status should be claimed_as_settled' do
          expect(job.subcontractor_status_name).to eq :claimed_as_settled
        end

        it 'subcon job: subcon status should be claim_settled' do
          expect(subcon_job.provider_status_name).to eq :claim_settled
        end

        it 'provider job: subcon settlement confirmation is allowed' do
          expect(job.subcontractor_status_events).to eq [:confirm_settled]
          expect(event_permitted_for_job?('subcontractor_status', 'confirm_settled', subcon_admin, subcon_job)).to be_true
        end

        it 'subcon job: provider settlement confirmation is not allowed for a user' do
          expect(subcon_job.provider_status_events).to eq [:provider_confirmed]
          expect(event_permitted_for_job?('provider_status', 'provider_confirmed', subcon_admin, subcon_job)).to be_false
        end

        it 'subcon account balance for prov should be: zero' do
          expect(job.organization.account_for(job.subcontractor.becomes(Organization)).balance).to eq Money.new(0)
        end

        it 'prov account balance for prov should be: zero' do
          expect(subcon_job.organization.account_for(job.provider.becomes(Organization)).balance).to eq Money.new(0)
        end

        context 'when provider confirms settlement' do
          before do
            job.confirm_settled_subcon!
            subcon_job.reload
          end

          it 'provider job: subcon status should be cleared' do
            expect(job.subcontractor_status_name).to eq :cleared
          end

          it 'subcon job: subcon status should be cleared' do
            expect(subcon_job.provider_status_name).to eq :cleared
          end

          it 'provider job: no subcon settlement events are left' do
            expect(job.subcontractor_status_events).to eq []
          end

          it 'subcon job: no provider settlement events are left' do
            expect(subcon_job.provider_status_events).to eq []
          end

          it 'subcon account balance for prov should be: zero' do
            expect(job.organization.account_for(job.subcontractor.becomes(Organization)).balance).to eq Money.new(0)
          end

          it 'prov account balance for prov should be: zero' do
            expect(subcon_job.organization.account_for(job.provider.becomes(Organization)).balance).to eq Money.new(0)
          end

        end

      end

      context 'when provider initiates the cash settlement' do
        before do
          job.subcon_payment = 'cash'
          job.settle_subcon!
          subcon_job.reload
        end

        it 'provider job: subcon status should be claim_settled' do
          expect(job.subcontractor_status_name).to eq :claim_settled
        end

        it 'subcon job: subcon status should be claimed_as_settled' do
          expect(subcon_job.provider_status_name).to eq :claimed_as_settled
        end

        it 'provider job: subcon settlement confirmation is NOT allowed' do
          expect(job.subcontractor_status_events).to eq [:subcon_confirmed]
          expect(event_permitted_for_job?('subcontractor_status', 'subcon_confirmed', subcon_admin, subcon_job)).to be_false
        end

        it 'subcon job: provider settlement confirmation is allowed' do
          expect(subcon_job.provider_status_events).to eq [:confirm_settled]
          expect(event_permitted_for_job?('provider_status', 'confirm_settled', subcon_admin, subcon_job)).to be_true
        end

        it 'subcon account balance for prov should be: zero' do
          expect(job.organization.account_for(job.subcontractor.becomes(Organization)).balance).to eq Money.new(0)
        end

        it 'prov account balance for prov should be: zero' do
          expect(subcon_job.organization.account_for(job.provider.becomes(Organization)).balance).to eq Money.new(0)
        end

        context 'when subcon confirms settlement' do
          before do
            subcon_job.confirm_settled_provider!
            job.reload
          end

          it 'provider job: subcon status should be pending' do
            expect(job.subcontractor_status_name).to eq :cleared
          end

          it 'subcon job: subcon status should be pending' do
            expect(subcon_job.provider_status_name).to eq :cleared
          end

          it 'provider job: no subcon settlement events are left' do
            expect(job.subcontractor_status_events).to eq []
          end

          it 'subcon job: no provider settlement events are left' do
            expect(subcon_job.provider_status_events).to eq []
          end

          it 'subcon account balance for prov should be: zero' do
            expect(job.organization.account_for(job.subcontractor.becomes(Organization)).balance).to eq Money.new(0)
          end

          it 'prov account balance for prov should be: zero' do
            expect(subcon_job.organization.account_for(job.provider.becomes(Organization)).balance).to eq Money.new(0)
          end

        end

      end

    end


  end

  context 'when collecting a payment' do
    before do
      transfer_the_job
      accept_the_job subcon_job
      start_the_job subcon_job
      add_bom_to_job subcon_job, cost: 100, price: 1000, quantity: 1
      collect_a_payment subcon_job, amount: 100, type: 'cash', collector: subcon
    end

    it 'provider job: subcon status should be pending' do
      expect(job.subcontractor_status_name).to eq :pending
    end

    it 'subcon job: subcon status should be pending' do
      expect(subcon_job.provider_status_name).to eq :pending
    end

    it 'provider job: subcon settlement is not allowed yet (need to deposit the collection first)' do
      expect(job.subcontractor_status_events).to_not include :settle
    end

    it 'subcon job: provider settlement is not allowed yet (need to deposit the collection first)' do
      expect(subcon_job.provider_status_events).to eq []
    end


    context 'when depositing the collected payment' do
      before do
        subcon_job.collection_entries.last.deposit!
        subcon_job.reload
        job.reload
      end

      it 'provider job: subcon settlement is not allowed yet (need to deposit the collection first)' do
        expect(job.subcontractor_status_events).to_not include :settle
      end

      it 'subcon job: provider settlement is not allowed yet (need to deposit the collection first)' do
        expect(subcon_job.provider_status_events).to eq []
      end

      context 'when confirming the deposit' do
        before do
          job.deposited_entries.last.confirm!
          job.reload
          subcon_job.reload
        end

        it 'provider job: subcon settlement is not allowed yet (need to deposit the collection first)' do
          expect(job.subcontractor_status_events).to_not include :settle
        end

        it 'subcon job: provider settlement is not allowed yet (need to deposit the collection first)' do
          expect(subcon_job.provider_status_events).to eq []
        end

        it 'subcon account balance for prov should be just the collection fee amount (100)' do
          expect(job.organization.account_for(job.subcontractor.becomes(Organization)).balance).to eq Money.new(100)
        end

        it 'subcon account balance for prov should be just the collection fee amount (-100)' do
          expect(subcon_job.organization.account_for(job.provider.becomes(Organization)).balance).to eq Money.new(-100)
        end


        context 'when job is done' do
          before do
            subcon_job.complete_work!
            job.reload
          end

          it 'subcon account balance for prov should be: collection fee amount - subcon fee - bom reimbu' do
            expect(job.organization.account_for(job.subcontractor.becomes(Organization)).balance).to eq Money.new(100 - 10000 -10000)
          end

          it 'prov account balance for prov should be: collection fee amount - subcon fee - bom reimbu' do
            expect(subcon_job.organization.account_for(job.provider.becomes(Organization)).balance).to eq Money.new(-100 + 10000 + 10000)
          end


          it 'provider job: subcon settlement is not allowed yet (need to deposit the collection first)' do
            expect(job.subcontractor_status_events).to include :settle
            expect(job.subcontractor_status_events).to include :subcon_marked_as_settled
          end

          it 'subcon job: provider settlement is not allowed yet (need to deposit the collection first)' do
            expect(subcon_job.provider_status_events).to eq [:provider_marked_as_settled, :settle]
          end

          it 'subcon is not allowed to invoke provider_marked_as_settled ' do
            expect(event_permitted_for_job?('provider_status', 'provider_marked_as_settled', subcon_admin, subcon_job)).to be_false
          end
        end


      end

    end
  end
end