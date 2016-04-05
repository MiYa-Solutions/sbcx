require 'spec_helper'

describe 'After completing the work' do

  include_context 'job transferred to local subcon'

  before do
    transfer_the_job job: job, bom_reimbursement: true
    accept_on_behalf_of_subcon job
    start_the_job job
    add_bom_to_job job, cost: 10, price: 100, quantity: 2, buyer: subcon
    complete_the_work job
  end

  it 'work status should be done' do
    expect(job.work_status_name).to eq :done
  end

  it 'customer balance should be 100' do
    expect(job.customer.account.reload.balance).to eq Money.new(20000)
  end

  it 'subcon balance should be 101' do
    expect(org.account_for(subcon).reload.balance).to eq Money.new(-12000)
  end

  context 'when re-opening the job' do
    before do
      reopen_the_job job
    end

    let(:adj_entry) { job.customer.account.reload.entries.where(type: 'ReopenedJobAdjustment').last }
    let(:subcon_adj_entry) { org.account_for(subcon).reload.entries.where(type: 'ReopenedJobAdjustment').last }

    it 'work status should be in_progress' do
      expect(job.work_status_name).to eq :in_progress
    end

    it 'should revert the customer balance to zero' do
      expect(job.customer.account.reload.balance).to eq Money.new(0)
    end

    it 'an adjustment entry for the customer should exist and with the amount of 200' do
      expect(adj_entry.amount).to eq Money.new(-20000)
    end

    it 'an adjustment entry for the subcon should exist and with the amount of 100' do
      expect(subcon_adj_entry.amount).to eq Money.new(12000)
    end

    it 'should revert the subcon balance to zero' do
      expect(org.account_for(subcon).reload.balance).to eq Money.new(0)
    end

    context 'when adding another bom' do
      before do
        add_bom_to_job job, cost: 10, price: 50, quantity: 1
      end

      context 'when completing the work (again)' do
        before do
          complete_the_work job
        end

        it 'work status should be done' do
          expect(job.work_status_name).to eq :done
        end

        it 'customer balance should be 200' do
          expect(job.customer.account.reload.balance).to eq Money.new(25000)
        end

        it 'subcon balance should be 120' do
          expect(org.account_for(subcon).reload.balance).to eq Money.new(-12000)
        end


        context 'when reopening the job (again)' do

          before do
            reopen_the_job job
          end

          it 'work status should be in_progress' do
            expect(job.work_status_name).to eq :in_progress
          end

          it 'should revert the customer balance to zero' do
            expect(job.customer.account.reload.balance).to eq Money.new(0)
          end

          it 'an adjustment entry should exist and with the amount of 250' do
            expect(adj_entry.amount).to eq Money.new(-25000)
          end

          it 'subcon balance should be zero' do
            expect(org.account_for(subcon).reload.balance).to eq Money.new(0)
          end

          it 'an adjustment entry for the subcon should exist and with the amount of 120' do
            expect(subcon_adj_entry.amount).to eq Money.new(12000)
          end

        end

        context 'after settling with the subcon' do

          before do
            job.reload
            settle_with_subcon job, type: 'cheque', amount: 120
          end

          it 'subcon balance should be zero' do
            expect(org.account_for(subcon).reload.balance).to eq Money.new(0)
          end



          context 'when reopening the job (again)' do

            before do
              reopen_the_job job
            end

            it 'work status should be in_progress' do
              expect(job.work_status_name).to eq :in_progress
            end

            it 'should revert the customer balance to zero' do
              expect(job.customer.account.reload.balance).to eq Money.new(0)
            end

            it 'an adjustment entry should exist and with the amount of 150' do
              expect(adj_entry.amount).to eq Money.new(-25000)
            end
            it 'the adjustment entry status should be cleared ' do
              expect(adj_entry.status_name).to eq :cleared
            end

          end

        end


      end
    end
  end
end