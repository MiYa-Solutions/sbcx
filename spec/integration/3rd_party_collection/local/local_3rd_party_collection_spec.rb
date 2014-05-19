require 'spec_helper'

describe 'My behaviour', skip_basic_job: true do

  let(:broker_job) { BrokerServiceCall.find(job.id) }

  include_context 'job transferred from a local provider' do
    let(:collection_allowed?) { true }
    let(:transfer_allowed?) { true }
  end
  include_context 'job transferred to local subcon'

  before do
    user.save!
    job.update_attributes(properties: { 'provider_fee' => '100', 'prov_bom_reimbursement' => 'true' })
    accept_the_job job
    transfer_the_job

    broker_job.accept_work
    start_the_job broker_job
    add_bom_to_job broker_job, cost: '100', price: '1000', quantity: '1', buyer: job.subcontractor

    user.destroy # a workaround for the factory to ensure a single user org
  end

  it 'there should be only one ticket created' do
    expect(Ticket.count).to eq 1
  end

  it 'expect provider to not be part of the available collectors' do
    expect(broker_job.available_payment_collectors).to eq [job.organization, job.subcontractor]
  end

  it 'broker: account balance for prov should be 0.00 ' do
    expect(org.account_for(broker_job.provider.becomes(Organization)).reload.balance).to eq Money.new(0)
  end

  it 'broker: account balance for subcon should be 0.00 ' do
    expect(org.account_for(broker_job.subcontractor.becomes(Organization)).reload.balance).to eq Money.new(0)
  end


  context 'when collecting on the behalf of the subcon' do
    before do
      collect_a_payment broker_job, amount: 100, type: 'cash', collector: broker_job.subcontractor
    end

    it 'prov collection status is partially_collected' do
      expect(broker_job.reload.prov_collection_status_name).to eq :partially_collected
    end

    it 'prov collection status is partially_collected' do
      expect(broker_job.reload.subcon_collection_status_name).to eq :partially_collected
    end

    it 'broker: account balance for prov should be -101.00 (collection + collection fee)' do
      expect(org.account_for(broker_job.provider.becomes(Organization)).reload.balance).to eq Money.new(-10000 - 100)
    end

    it 'broker: account balance for subcon should be 101.00 (collection + collection fee)' do
      expect(org.account_for(broker_job.subcontractor.becomes(Organization)).reload.balance).to eq Money.new(10000 + 100)
    end


    context 'when completing the work' do

      before do
        complete_the_work broker_job
        broker_job.reload
      end

      it 'billing events should be collcet' do
        expect(broker_job.billing_status_events.sort).to eq [:collect]
      end

      it 'broker: account balance for prov should be -101.00 (collection + collection fee - subcon fee - bom)' do
        expect(org.account_for(broker_job.provider.becomes(Organization)).balance).to eq Money.new(-10000 - 100 + 10000 + 10000)
      end

      it 'broker: account balance for subcon should be 101.00 (collection + collection fee - subcon fee - bom)' do
        expect(org.account_for(broker_job.subcontractor.becomes(Organization)).balance).to eq Money.new(10000 + 100 - 10000 -10000)
      end

      context 'when broker collects the remainder' do
        before do
          collect_full_amount broker_job
        end

        it 'billing events should be empty' do
          expect(broker_job.billing_status_events.sort).to eq []
        end

        it 'broker: account balance for prov should be -101.00 (2 collections + 2 collection fees - subcon fee - bom)' do
          expect(org.account_for(broker_job.provider.becomes(Organization)).balance).to eq Money.new(-90000 - 900 -10000 - 100 + 10000 + 10000)
        end

        it 'broker: account balance for subcon should be 101.00 (collection + collection fee - subcon fee - bom)' do
          expect(org.account_for(broker_job.subcontractor.becomes(Organization)).balance).to eq Money.new(10000 + 900 + 100 - 10000 -10000)
        end

        context 'when marking the subcon collection as deposited' do
          before do
            broker_job.collected_entries.last.deposited!
            broker_job.reload
          end

          it 'subcon collection status should be is_deposited' do
            expect(broker_job.subcon_collection_status_name).to eq :is_deposited
          end

          it 'broker: account balance for prov should be -801.00 (2 collections + 2 collection fees - subcon fee - bom)' do
            expect(org.account_for(broker_job.provider.becomes(Organization)).balance).to eq Money.new(-90000 - 900 -10000 - 100 + 10000 + 10000)
          end

          it 'broker: account balance for subcon should be -100.00 (collection fees - subcon fee - bom)' do
            expect(org.account_for(broker_job.subcontractor.becomes(Organization)).balance).to eq Money.new(900 + 100 - 10000 -10000)
          end

          context 'when confirming the subcon desposit' do
            before do
              broker_job.deposited_entries.last.confirm!
              broker_job.reload
            end

            it 'subcon collection status should be is_deposited' do
              expect(broker_job.subcon_collection_status_name).to eq :deposited
            end

            it 'provider collection status should be is_deposited' do
              expect(broker_job.prov_collection_status_name).to eq :collected
            end

            it 'broker: account balance for prov should be -801.00 (2 collections + 2 collection fees - subcon fee - bom)' do
              expect(org.account_for(broker_job.provider.becomes(Organization)).balance).to eq Money.new(-90000 - 900 -10000 - 100 + 10000 + 10000)
            end

            it 'broker: account balance for subcon should be -100.00 (collection fees - subcon fee - bom)' do
              expect(org.account_for(broker_job.subcontractor.becomes(Organization)).balance).to eq Money.new(900 + 100 - 10000 -10000)
            end

            context 'when depositing the first collection to the prov' do
              before do
                broker_job.collection_entries.first.deposit!
                broker_job.reload
              end

              it 'subcon collection status should be is_deposited' do
                expect(broker_job.subcon_collection_status_name).to eq :deposited
              end

              it 'provider collection status should be is_deposited' do
                expect(broker_job.prov_collection_status_name).to eq :collected
              end

              it 'broker: account balance for prov should be -801.00 (2 collections + 2 collection fees - subcon fee - bom)' do
                expect(org.account_for(broker_job.provider.becomes(Organization)).balance).to eq Money.new(-90000 - 900  - 100 + 10000 + 10000)
              end

              it 'broker: account balance for subcon should be -100.00 (collection fees - subcon fee - bom)' do
                expect(org.account_for(broker_job.subcontractor.becomes(Organization)).balance).to eq Money.new(900 + 100 - 10000 -10000)
              end

              context 'when depositing the second collection' do
                before do
                  broker_job.collection_entries.last.deposit!
                  broker_job.reload
                end
                it 'subcon collection status should be is_deposited' do
                  expect(broker_job.subcon_collection_status_name).to eq :deposited
                end

                it 'provider collection status should be is_deposited' do
                  expect(broker_job.prov_collection_status_name).to eq :is_deposited
                end

                it 'broker: account balance for prov should be -801.00 (2 collections + 2 collection fees - subcon fee - bom)' do
                  expect(org.account_for(broker_job.provider.becomes(Organization)).balance).to eq Money.new(- 900  - 100 + 10000 + 10000)
                end

                it 'broker: account balance for subcon should be -100.00 (collection fees - subcon fee - bom)' do
                  expect(org.account_for(broker_job.subcontractor.becomes(Organization)).balance).to eq Money.new(900 + 100 - 10000 -10000)
                end

                context 'when confirming the deposits' do
                  before do
                    broker_job.deposit_entries.first.confirmed!
                    broker_job.deposit_entries.last.confirmed!
                    broker_job.reload
                  end

                  it 'subcon collection status should be is_deposited' do
                    expect(broker_job.subcon_collection_status_name).to eq :deposited
                  end

                  it 'provider collection status should be is_deposited' do
                    expect(broker_job.prov_collection_status_name).to eq :deposited
                  end

                  it 'broker: account balance for prov should be -801.00 (2 collections + 2 collection fees - subcon fee - bom)' do
                    expect(org.account_for(broker_job.provider.becomes(Organization)).balance).to eq Money.new(- 900  - 100 + 10000 + 10000)
                  end

                  it 'broker: account balance for subcon should be -100.00 (collection fees - subcon fee - bom)' do
                    expect(org.account_for(broker_job.subcontractor.becomes(Organization)).balance).to eq Money.new(900 + 100 - 10000 -10000)
                  end

                end

                context 'when disputing one of the deposits' do
                  before do
                    broker_job.deposit_entries.first.disputed!
                    broker_job.reload
                  end

                  it 'subcon collection status should be is_deposited' do
                    expect(broker_job.subcon_collection_status_name).to eq :deposited
                  end

                  it 'provider collection status should be is_deposited' do
                    expect(broker_job.prov_collection_status_name).to eq :disputed
                  end

                  it 'broker: account balance for prov should be -801.00 (2 collections + 2 collection fees - subcon fee - bom)' do
                    expect(org.account_for(broker_job.provider.becomes(Organization)).balance).to eq Money.new(- 900  - 100 + 10000 + 10000)
                  end

                  it 'broker: account balance for subcon should be -100.00 (collection fees - subcon fee - bom)' do
                    expect(org.account_for(broker_job.subcontractor.becomes(Organization)).balance).to eq Money.new(900 + 100 - 10000 -10000)
                  end

                  context 'when confirming the second entry' do
                    before do
                      broker_job.deposit_entries.last.confirmed!
                      broker_job.reload
                    end

                    it 'subcon collection status should be is_deposited' do
                      expect(broker_job.subcon_collection_status_name).to eq :deposited
                    end

                    it 'provider collection status should be is_deposited' do
                      expect(broker_job.prov_collection_status_name).to eq :disputed
                    end

                    it 'broker: account balance for prov should be -801.00 (2 collections + 2 collection fees - subcon fee - bom)' do
                      expect(org.account_for(broker_job.provider.becomes(Organization)).balance).to eq Money.new(- 900  - 100 + 10000 + 10000)
                    end

                    it 'broker: account balance for subcon should be -100.00 (collection fees - subcon fee - bom)' do
                      expect(org.account_for(broker_job.subcontractor.becomes(Organization)).balance).to eq Money.new(900 + 100 - 10000 -10000)
                    end

                    context 'when confirming the first entry' do
                      before do
                        broker_job.deposit_entries.first.confirmed!
                        broker_job.reload
                      end

                      it 'subcon collection status should be is_deposited' do
                        expect(broker_job.subcon_collection_status_name).to eq :deposited
                      end

                      it 'provider collection status should be is_deposited' do
                        expect(broker_job.prov_collection_status_name).to eq :deposited
                      end

                      it 'broker: account balance for prov should be -801.00 (2 collections + 2 collection fees - subcon fee - bom)' do
                        expect(org.account_for(broker_job.provider.becomes(Organization)).balance).to eq Money.new(- 900  - 100 + 10000 + 10000)
                      end

                      it 'broker: account balance for subcon should be -100.00 (collection fees - subcon fee - bom)' do
                        expect(org.account_for(broker_job.subcontractor.becomes(Organization)).balance).to eq Money.new(900 + 100 - 10000 -10000)
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


end