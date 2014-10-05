require 'spec_helper'

describe 'Local Broker Settlement', skip_basic_job: true do
  let(:broker_job) { BrokerServiceCall.find(job.id) }

  include_context 'job transferred from a local provider' do
    let(:collection_allowed?) { true }
    let(:transfer_allowed?) { true }
  end

  include_context 'job transferred to local subcon'

  context 'when NOT collecting payments (before work completion)' do

    before do
      user.save!
      job.update_attributes(properties: { 'provider_fee' => '100', 'prov_bom_reimbursement' => 'true' })
      accept_the_job job
      transfer_the_job

      broker_job.accept_work
      start_the_job broker_job
      add_bom_to_job broker_job, cost: '100', price: '1000', quantity: '1', buyer: job.subcontractor
    end

    it 'broker_job: subcon status should be pending' do
      expect(broker_job.subcontractor_status_name).to eq :pending
    end

    it 'broker_job: provider status should be pending' do
      expect(broker_job.provider_status_name).to eq :pending
    end

    it 'broker_job: subcon settlement is not allowed yet (need to complete the work first)' do
      expect(broker_job.subcontractor_status_events).to_not include :settle
    end

    it 'broker_job: provider settlement is not allowed yet (need to complete the first)' do
      expect(broker_job.provider_status_events).to eq []
    end

    context 'after work completion' do
      before do
        complete_the_work broker_job
      end

      it 'broker_job: subcon settlement is allowed' do
        expect(broker_job.subcontractor_status_events).to include :settle
        expect(event_permitted_for_job?('subcontractor_status', 'settle', org_admin, broker_job)).to be_true

      end

      it 'broker_job: provider settlement is allowed ' do
        expect(broker_job.provider_status_events).to eq [:settle]
        expect(event_permitted_for_job?('provider_status', 'settle', org_admin, broker_job)).to be_true
      end

      context 'when settling with the provider using a cheque' do
        before do
          broker_job.provider_payment = 'cheque'
          broker_job.settle_provider!
        end

        it 'broker_job: subcon status should be pending' do
          expect(broker_job.subcontractor_status_name).to eq :pending
        end

        it 'broker_job: subcon status should be settled' do
          expect(broker_job.provider_status_name).to eq :settled
        end

        it 'broker_job: is able to settle with subcon' do
          expect(broker_job.subcontractor_status_events).to include :settle
          expect(event_permitted_for_job?('subcontractor_status', 'settle', org_admin, broker_job)).to be_true
        end

        it 'broker_job: allowed to mark the job as cleared' do
          expect(broker_job.provider_status_events).to eq [:clear]
          expect(event_permitted_for_job?('provider_status', 'clear', org_admin, broker_job)).to be_true
        end

        it 'prov account balance for prov should be: -200 (subcon fee and reimbursement)' do
          expect(broker_job.organization.account_for(broker_job.subcontractor.becomes(Organization)).balance).to eq Money.new(-20000)
        end

        it 'prov account balance for prov should be: zero' do
          expect(broker_job.organization.account_for(broker_job.provider.becomes(Organization)).balance).to eq Money.new(0)
        end

        context 'when provider confirms settlement' do

          context 'when subcon marks the settlement as cleared' do
            before do
              broker_job.clear_provider!
            end

            it 'broker_job: subcon status should be cleared' do
              expect(broker_job.subcontractor_status_name).to eq :pending
            end

            it 'broker_job: subcon status should be cleared' do
              expect(broker_job.provider_status_name).to eq :cleared
            end

            it 'broker_job: should be able to settle with subcon' do
              expect(broker_job.subcontractor_status_events).to include :settle
            end

            it 'broker_job: there are no more settlement events available' do
              expect(broker_job.provider_status_events).to eq []
            end

          end

        end

      end

      context 'when setteling with the subcon with a cheque' do
        before do
          broker_job.subcon_payment = 'cheque'
          broker_job.settle_subcon!
        end

        it 'broker_job: subcon status should be settled' do
          expect(broker_job.subcontractor_status_name).to eq :settled
        end

        it 'broker_job: provider settlement status should be pending' do
          expect(broker_job.provider_status_name).to eq :pending
        end

        it 'broker_job: subcon settlement clearing is not allowed for user' do
          expect(broker_job.subcontractor_status_events).to eq [:clear]
          expect(event_permitted_for_job?('subcontractor_status', 'clear', org_admin, broker_job)).to be_true
        end

        it 'broker_job: provider settlement is permitted for a user' do
          expect(broker_job.provider_status_events).to eq [:settle]
          expect(event_permitted_for_job?('provider_status', 'settle', org_admin, broker_job)).to be_true
        end

        it 'subcon account balance for prov should be: zero' do
          expect(broker_job.organization.account_for(broker_job.subcontractor.becomes(Organization)).balance).to eq Money.new(0)
        end

        it 'prov account balance for prov should be: 200 (subcon fee + bom reimbur)' do
          expect(broker_job.organization.account_for(broker_job.provider.becomes(Organization)).balance).to eq Money.new(20000)
        end

        context 'when clearing the subcon settlement' do
          before do
            broker_job.clear_subcon!
          end

          it 'broker_job: subcon status should be cleared' do
            expect(broker_job.subcontractor_status_name).to eq :cleared
          end

          it 'broker_job: subcon status should be pending' do
            expect(broker_job.provider_status_name).to eq :pending
          end

          it 'broker_job: no subcon settlement events are left' do
            expect(broker_job.subcontractor_status_events).to eq []
          end

          it 'broker_job: provider settlement events are settle' do
            expect(broker_job.provider_status_events).to eq [:settle]
          end

        end


      end

      context 'when settling with the provider with cash=' do
        before do
          broker_job.provider_payment = 'cash'
          broker_job.settle_provider!
        end

        it 'broker_job: subcon status should be pending' do
          expect(broker_job.subcontractor_status_name).to eq :pending
        end

        it 'broker_job: subcon status should be cleared' do
          expect(broker_job.provider_status_name).to eq :cleared
        end

        it 'broker_job: subcon settlement confirmation is allowed' do
          expect(broker_job.subcontractor_status_events).to include :settle
          expect(event_permitted_for_job?('subcontractor_status', 'settle', org_admin, broker_job)).to be_true
        end

        it 'broker_job: no provider settlement events are available' do
          expect(broker_job.provider_status_events).to eq []
        end

        it 'subcon account balance for prov should be: -200 (subcon fee + bon reimbur)' do
          expect(broker_job.organization.account_for(broker_job.subcontractor.becomes(Organization)).balance).to eq Money.new(-20000)
        end

        it 'prov account balance for prov should be: zero' do
          expect(broker_job.organization.account_for(broker_job.provider.becomes(Organization)).balance).to eq Money.new(0)
        end

      end

      context 'when settling with the subcon with cash' do
        before do
          broker_job.subcon_payment = 'cash'
          broker_job.settle_subcon!
        end

        it 'broker_job: subcon status should be claim_settled' do
          expect(broker_job.subcontractor_status_name).to eq :cleared
        end

        it 'broker_job: subcon status should be pending' do
          expect(broker_job.provider_status_name).to eq :pending
        end

        it 'broker_job: no subcon settlement events are left' do
          expect(broker_job.subcontractor_status_events).to eq []
        end

        it 'broker_job: provider settlement is allowed' do
          expect(broker_job.provider_status_events).to eq [:settle]
          expect(event_permitted_for_job?('provider_status', 'settle', org_admin, broker_job)).to be_true
        end

        it 'subcon account balance for prov should be: zero' do
          expect(broker_job.organization.account_for(broker_job.subcontractor.becomes(Organization)).balance).to eq Money.new(0)
        end

        it 'prov account balance for prov should be: 200 (subcon fee + bom reimbur)' do
          expect(broker_job.organization.account_for(broker_job.provider.becomes(Organization)).balance).to eq Money.new(20000)
        end

      end

    end

  end

  context 'when collecting a payment' do
    before do
      user.save!
      job.update_attributes(properties: { 'provider_fee' => '100', 'prov_bom_reimbursement' => 'true' })
      accept_the_job job
      transfer_the_job

      broker_job.accept_work
      start_the_job broker_job
      add_bom_to_job broker_job, cost: '100', price: '1000', quantity: '1', buyer: job.subcontractor
      collect_a_payment broker_job, amount: 100, type: 'cash', collector: broker_job.subcontractor
    end

    it 'broker_job: subcon status should be pending' do
      expect(broker_job.subcontractor_status_name).to eq :pending
    end

    it 'broker_job: subcon status should be pending' do
      expect(broker_job.provider_status_name).to eq :pending
    end

    it 'broker_job: subcon settlement is not allowed yet (need to deposit the collection first)' do
      expect(broker_job.subcontractor_status_events).to_not include :settle
    end

    it 'broker_job: provider settlement is not allowed yet (need to deposit the collection first)' do
      expect(broker_job.provider_status_events).to eq []
    end


    context 'when depositing the collected payment' do
      before do
        broker_job.collection_entries.last.deposit!
        broker_job.reload
      end

      it 'broker_job: subcon settlement is not allowed yet (need to deposit the collection first)' do
        expect(broker_job.subcontractor_status_events).to_not include :settle
      end

      it 'subcon job: provider settlement is not allowed yet (need to deposit the collection first)' do
        expect(broker_job.provider_status_events).to eq []
      end

      context 'when confirming the deposit' do
        before do
          broker_job.deposit_entries.last.confirmed!
          broker_job.reload
        end

        it 'provider job: subcon settlement is not allowed yet (need to deposit the collection first)' do
          expect(broker_job.subcontractor_status_events).to_not include :settle
        end

        it 'subcon job: provider settlement is not allowed yet (need to deposit the collection first)' do
          expect(broker_job.provider_status_events).to eq []
        end

        it 'subcon account balance for prov should be just the collection fee amount (100 + subcon fee)' do
          expect(broker_job.organization.account_for(broker_job.subcontractor.becomes(Organization)).balance).to eq Money.new(10100)
        end

        it 'subcon account balance for prov should be just the collection fee amount (-100)' do
          expect(broker_job.organization.account_for(broker_job.provider.becomes(Organization)).balance).to eq Money.new(-100)
        end


        context 'when job is done' do
          before do
            broker_job.complete_work!
          end

          it 'subcon account balance for prov should be: collection fee amount - subcon fee)' do
            expect(broker_job.organization.account_for(broker_job.subcontractor.becomes(Organization)).balance).to eq Money.new(100 - 10000)
          end

          it 'prov account balance for prov should be: collection fee amount - subcon fee - bom reimbu' do
            expect(broker_job.organization.account_for(broker_job.provider.becomes(Organization)).balance).to eq Money.new(-100 + 10000 + 10000)
          end


          it 'provider job: subcon settlement is not allowed yet (need to deposit the collection first)' do
            expect(broker_job.subcontractor_status_events).to_not include :settle
          end

          it 'subcon job: provider settlement is allowed (as the collection was deposited and confirmed by prov)' do
            expect(broker_job.provider_status_events).to eq [:settle]
          end

          context 'when depositing the subcon collection' do
            before do
              broker_job.collected_entries.last.deposited!
            end

            it 'provider job: subcon settlement is not allowed yet (need to confirm the deposit first)' do
              expect(broker_job.subcontractor_status_events).to_not include :settle
            end

            context 'when confirming the subcon deposit' do
              before do
                broker_job.deposited_entries.last.confirm!
              end

              it 'provider job: subcon settlement is not allowed yet (need to confirm the deposit first)' do
                expect(broker_job.subcontractor_status_events).to include :settle
              end

              context 'when settling with subcon' do
                before do
                  broker_job.subcon_payment = 'cash'
                  broker_job.settle_subcon!
                end

                it 'broker_job: subcon status should be cleared' do
                  expect(broker_job.subcontractor_status_name).to eq :cleared
                end

                it 'subcon account balance for subcon should be: zero' do
                  expect(broker_job.organization.account_for(broker_job.subcontractor.becomes(Organization)).balance).to eq Money.new(0)
                end

                context 'when settling with the provider' do
                  before do
                    broker_job.provider_payment = 'cash'
                    broker_job.settle_provider!
                  end

                  it 'broker_job: provider status should be cleared' do
                    expect(broker_job.subcontractor_status_name).to eq :cleared
                  end

                  it 'prov account balance for provider should be: zero' do
                    expect(broker_job.organization.account_for(broker_job.provider.becomes(Organization)).balance).to eq Money.new(0)
                  end

                  it 'can close the job' do
                    expect(broker_job.status_events).to include :close
                  end

                  context 'when closing the job' do
                    before do
                      broker_job.close!
                    end

                    it 'status should be closed' do
                      expect(broker_job.status_name).to eq :closed
                    end
                  end


                end

              end

            end


          end

        end

      end

    end
  end
end