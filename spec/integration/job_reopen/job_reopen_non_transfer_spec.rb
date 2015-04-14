require 'spec_helper'

describe 'After completing the work' do

  include_context 'basic job testing'

  before do
    start_the_job job
    add_bom_to_job job, cost: 10, price: 100, quantity: 1
    complete_the_work job
  end

  it 'work status should be done' do
    expect(job.work_status_name).to eq :done
  end

  it 'customer balance should be 100' do
    expect(job.customer.account.reload.balance).to eq Money.new(10000)
  end

  context 'when re-opening the job' do
    before do
      reopen_the_job job
    end

    let(:adj_entry) { job.customer.account.reload.entries.where(type: 'MyAdjEntry').last }

    it 'work status should be in_progress' do
      expect(job.work_status_name).to eq :in_progress
    end

    it 'should revert the customer balance to zero' do
      expect(job.customer.account.reload.balance).to eq Money.new(0)
    end

    it 'an adjustment entry should exist and with the amount of 100' do
      expect(adj_entry.amount).to eq Money.new(-10000)
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
          expect(job.customer.account.reload.balance).to eq Money.new(15000)
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
            expect(adj_entry.amount).to eq Money.new(-15000)
          end

        end

        context 'after creating an invoice' do
          let(:the_invoice) { job.invoices.last }

          before do
            job.reload
            invoice job
          end

          it 'invoice amount should be 150' do
            expect(the_invoice.total).to eq Money.new(15000)
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
              expect(adj_entry.amount).to eq Money.new(-15000)
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