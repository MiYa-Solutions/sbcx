require 'spec_helper'

describe 'When transferred from local subcon' do
  let(:collection_allowed?) { true }
  let(:transfer_allowed?) { true }
  include_context 'job transferred from a local provider'

  it 'job status should be new' do
    expect(job.status_name).to eq :new
  end


  describe 'when transferring the job to a local subcon' do
    let(:subcon_agr) { FactoryGirl.build(:local_subcon_agr, organization: org) }
    let(:subcon) { subcon_agr.counterparty }

    let(:broker_job) { BrokerServiceCall.find(job.id) }

    before do
      accept_the_job job
      transfer_the_job job: job, agreement: subcon_agr, subcon: subcon
    end

    it 'should be of type BrokerServiceCall' do
      expect(broker_job.type).to eq 'BrokerServiceCall'
    end

    context 'when added boms and completed the work' do
      before do
        accept_on_behalf_of_subcon broker_job
        start_the_job broker_job
        add_bom_to_job broker_job, quantity: 1, cost: 10, price: 100, buyer: job.organization
        complete_the_work broker_job
      end

      it 'my _profit should be 100' do
        expect(job.my_profit).to eq Money.new(5500)
      end

      it 'provider account balance should be 110' do
        expect(org.account_for(job.provider.becomes(Organization)).balance).to eq Money.new(11000)
      end

      it 'subcon account balance should be -45' do
        expect(org.account_for(job.subcontractor.becomes(Organization)).balance).to eq Money.new(-4500)
      end

      context 'when reopening the job' do
        before do
          reopen_the_job broker_job
        end

        it 'work status should be set to in_progress' do
          expect(broker_job.work_status_name).to eq :in_progress
        end

        it 'provider account balance should be 0' do
          expect(org.account_for(broker_job.provider.becomes(Organization)).balance).to eq Money.new(0)
        end

        it 'subcon account balance should be 0' do
          expect(org.account_for(broker_job.subcontractor.becomes(Organization)).balance).to eq Money.new(0)
        end

        context 'when adding another the bom' do
          before do
            add_bom_to_job broker_job, quantity: 1, price: 50, cost: 10, buyer: broker_job.subcontractor
            broker_job.reload
          end

          context 'when completing the work' do
            before do
              complete_the_work broker_job
            end

            it 'my_profit should be 35' do
              expect(broker_job.my_profit).to eq Money.new(3500)
            end

            it 'provider account balance should be 120' do
              expect(org.account_for(broker_job.provider.becomes(Organization)).balance).to eq Money.new(12000)
            end

            it 'subcon account balance should be 65' do
              expect(org.account_for(broker_job.subcontractor.becomes(Organization)).balance).to eq Money.new(-7500)
            end

            context 'when reopening (again)' do
              before do
                reopen_the_job broker_job
              end

              it 'provider account balance should be zero' do
                expect(org.account_for(broker_job.provider.becomes(Organization)).balance).to eq Money.new(0)
              end

            end

            context 'when settling with the provider' do

              before do
                settle_with_provider broker_job
                broker_job.reload
              end

              it 'provider account balance should be 0' do
                expect(org.account_for(broker_job.provider.becomes(Organization)).balance).to eq Money.new(0)
              end

              it 'subcon account balance should be 0' do
                expect(org.account_for(broker_job.subcontractor.becomes(Organization)).balance).to eq Money.new(-7500)
              end

              context 'when settling with the subcon' do
                before do
                  settle_with_subcon broker_job
                  broker_job
                end

                it 'subcon account balance should be 0' do
                  expect(org.account_for(broker_job.subcontractor.becomes(Organization)).balance).to eq Money.new(0)
                end

                it 'subcon status should be cleared' do
                  expect(broker_job.subcontractor_status_name).to eq :cleared
                end
                context 'when reopening the job' do
                  before do
                    reopen_the_job broker_job
                    broker_job.reload
                  end

                  it 'expect provider status to be pending' do
                    expect(broker_job.provider_status_name).to eq :pending
                  end

                  it 'expect subcon status to be pending' do
                    expect(broker_job.subcontractor_status_name).to eq :pending
                  end

                  it 'provider account balance should be 0' do
                    expect(org.account_for(broker_job.provider.becomes(Organization)).balance).to eq Money.new(-12000)
                  end

                  it 'subcon account balance should be 0' do
                    expect(org.account_for(broker_job.subcontractor.becomes(Organization)).balance).to eq Money.new(7500)
                  end

                  context 'when adding another bom and completing the job' do
                    before do
                      add_bom_to_job broker_job, quantity: 1, price: 50, cost: 10, buyer: org
                      complete_the_work broker_job
                    end

                    it 'provider account balance should be 10' do
                      expect(org.account_for(broker_job.provider.becomes(Organization)).balance).to eq Money.new(1000)
                    end

                    it 'subcon account balance should be -20' do
                      expect(org.account_for(broker_job.subcontractor.becomes(Organization)).balance).to eq Money.new(-2000)
                    end

                    context 'when settling with the provider (again)' do
                      before do
                        settle_with_provider broker_job
                        broker_job.reload
                      end

                      it 'expect provider status to be cleared' do
                        expect(broker_job.provider_status_name).to eq :cleared
                      end

                      it 'provider account balance should be zero' do
                        expect(org.account_for(broker_job.provider.becomes(Organization)).balance).to eq Money.new(0)
                      end

                    end

                    context 'when settling with the subcon (again)' do
                      before do
                        settle_with_subcon broker_job
                        broker_job.reload
                      end

                      it 'expect provider status to be cleared' do
                        expect(broker_job.subcontractor_status_name).to eq :cleared
                      end

                      it 'provider account balance should be zero' do
                        expect(org.account_for(broker_job.subcontractor.becomes(Organization)).balance).to eq Money.new(0)
                      end

                    end

                  end

                end

              end


              context 'when reopening the job' do
                before do
                  reopen_the_job broker_job
                  broker_job.reload
                end

                it 'expect provider status to be pending' do
                  expect(broker_job.provider_status_name).to eq :pending
                end

                it 'expect subcon status to be pending' do
                  expect(broker_job.subcontractor_status_name).to eq :pending
                end

                it 'provider account balance should be -120' do
                  expect(org.account_for(broker_job.provider.becomes(Organization)).balance).to eq Money.new(-12000)
                end

                it 'subcon account balance should be zero' do
                  expect(org.account_for(broker_job.subcontractor.becomes(Organization)).balance).to eq Money.new(0)
                end

                context 'when adding another bom and completing the job' do
                  before do
                    add_bom_to_job broker_job, quantity: 1, price: 50, cost: 10, buyer: org
                    complete_the_work broker_job
                  end

                  it 'provider account balance should be -10' do
                    expect(org.account_for(broker_job.provider.becomes(Organization)).balance).to eq Money.new(1000)
                  end

                  it 'subcon account balance should be 0' do
                    expect(org.account_for(broker_job.subcontractor.becomes(Organization)).balance).to eq Money.new(-9500)
                  end

                  context 'when settling with the provider (again)' do
                    before do
                      settle_with_provider broker_job
                      broker_job.reload
                    end

                    it 'expect provider status to be cleared' do
                      expect(broker_job.provider_status_name).to eq :cleared
                    end

                    it 'provider account balance should be zero' do
                      expect(org.account_for(broker_job.provider.becomes(Organization)).balance).to eq Money.new(0)
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