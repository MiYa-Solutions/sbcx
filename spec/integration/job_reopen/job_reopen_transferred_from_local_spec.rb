require 'spec_helper'

describe 'When transferred from local subcon' do
  let(:collection_allowed?) {true}
  let(:can_transfer?) {true}
  include_context 'job transferred from a local provider'

  it 'job status should be new' do
    expect(job.status_name).to eq :new
  end
  it 'job type should be SubconServiceCall' do
    expect(job.type).to eq 'SubconServiceCall'
  end

  context 'when added boms and completed the work' do
    before do
      accept_the_job job
      start_the_job job
      add_bom_to_job job, quantity: 1, cost: 10, price: 100, buyer: job.organization
      complete_the_work job
    end

    it 'my _profit should be 100' do
      expect(job.my_profit).to eq Money.new(10000)
    end

    it 'provider account balance should be 110' do
      expect(org.account_for(job.provider.becomes(Organization)).balance).to eq Money.new(11000)
    end

    context 'when reopening the job' do
      before do
        reopen_the_job job
      end

      it 'work status should be set to in_progress' do
        expect(job.work_status_name).to eq :in_progress
      end

      it 'provider account balance should be 0' do
        expect(org.account_for(job.provider.becomes(Organization)).balance).to eq Money.new(0)
      end

      context 'when adding another the bom' do
        before do
          add_bom_to_job job, quantity: 1, price: 50, cost: 10, buyer: org
          job.reload
        end

        context 'when completing the work' do
          before do
            complete_the_work job
          end

          it 'my _profit should be 100' do
            expect(job.my_profit).to eq Money.new(10000)
          end

          it 'provider account balance should be 120' do
            expect(org.account_for(job.provider.becomes(Organization)).balance).to eq Money.new(12000)
          end

          context 'when reopening (again)' do
            before do
              reopen_the_job job
            end

            it 'provider account balance should be zero' do
              expect(org.account_for(job.provider.becomes(Organization)).balance).to eq Money.new(0)
            end

          end

          context 'when settling with the provider' do

            before do
              settle_with_provider job, type: 'cheque', amount: 120
              job.reload
            end

            it 'provider account balance should be 0' do
              expect(org.account_for(job.provider.becomes(Organization)).balance).to eq Money.new(0)
            end

            context 'when reopening the job' do
              before do
                reopen_the_job job
                job.reload
              end

              it 'expect provider status to be pending' do
                expect(job.provider_status_name).to eq :pending
              end

              it 'provider account balance should be 0' do
                expect(org.account_for(job.provider.becomes(Organization)).balance).to eq Money.new(-12000)
              end

              context 'when adding another bom and completing the job' do
                before do
                  add_bom_to_job job, quantity: 1, price: 50, cost: 10, buyer: org
                  complete_the_work job
                end

                it 'provider account balance should be -10' do
                  expect(org.account_for(job.provider.becomes(Organization)).balance).to eq Money.new(1000)
                end

                context 'when settling with the provider (again)' do
                  before do
                    settle_with_provider job, type: 'cash', amount: 10
                    confirm_all_provider_payments job
                    deposit_all_provider_payments job
                    clear_all_provider_payments job
                    job.reload
                  end

                  it 'expect provider status to be cleared' do
                    expect(job.provider_status_name).to eq :cleared
                  end

                  it 'provider account balance should be zero' do
                    expect(org.account_for(job.provider.becomes(Organization)).balance).to eq Money.new(0)
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