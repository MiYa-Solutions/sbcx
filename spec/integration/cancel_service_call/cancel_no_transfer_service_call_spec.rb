require 'spec_helper'

describe 'Cancel My Job - No Transfer' do

  include_context 'basic job testing'
  describe 'before work starts' do
    before do
      cancel_the_job job
    end
    it 'status should be changed to canceled' do
      expect(job.status_name).to eq :canceled
    end
  end

  describe 'after the work starts and boms were added' do
    before do
      job.start_work!
      add_bom_to_job job, cost: 100, price: 1000, quantity: 1
      cancel_the_job job
    end

    it 'status should be changed to canceled' do
      expect(job.status_name).to eq :canceled
    end

    it 'my profit should show the lost' do
      expect(job.my_profit).to eq Money.new(-10000)
    end
  end

  describe 'after the work is completed and the customer is charged' do
    before do
      job.start_work!
      add_bom_to_job job, cost: 100, price: 1000, quantity: 1
      job.complete_work!
      cancel_the_job job
    end

    it 'status should be changed to canceled' do
      expect(job.status_name).to eq :canceled
    end

    it 'the customer should be reimbursed' do
      expect(job.customer.account.balance).to eq Money.new(0)
    end

    it 'the customer should be reimbursed' do
      expect(job.entries.where(type: 'CanceledJobAdjustment').sum(:amount_cents)).to eq -100000
    end


  end

  describe 'when a payment is partially collected' do

    before do
      collect_a_payment job, amount: 100, type: 'cheque'
    end

    context 'when the payment is deposited' do
      before do
        job.payments.last.deposit!
      end

      describe 'when canceling the job' do
        before do
          cancel_the_job job
          job.reload
        end

        it 'status should be changed to canceled' do
          expect(job.status_name).to eq :canceled
        end

        it 'billing status should be in_process' do
          expect(job.billing_status_name).to eq :in_process
        end


      end

      context ' when the payment is cleared' do
        before do
          job.payments.last.clear!
          job.reload
        end

        context 'and cancelling the job' do
          before do
            cancel_the_job job
            job.reload
          end
          it 'status should be changed to canceled' do
            expect(job.status_name).to eq :canceled
          end

          it 'billing status should be over paid' do
            expect(job.billing_status_name).to eq :over_paid
          end
        end
      end

    end

  end

  describe 'when a payment was fully collected and job completed' do
    before do
      collect_a_payment job, amount: 100, type: 'cash'
      start_the_job job
      add_bom_to_job job, cost: 100, price: 1000, quantity: 1
      collect_a_payment job, amount: 900, type: 'cheque'
      complete_the_work job
      job.reload
      cancel_the_job job
      job.reload
    end

    it 'status should be changed to canceled' do
      expect(job.status_name).to eq :canceled
    end

    it 'billing status should be collected' do
      expect(job.billing_status_name).to eq :collected
    end

    context 'when depositing all entries' do
      before do
        deposit_all_entries job.payments
        job.reload
      end

      it 'billing status should be in process' do
        expect(job.billing_status_name).to eq :in_process
      end

      context 'when clearing all entries' do
        before do
          job.payments.last.clear!
          job.reload
        end

        it 'billing status should be over paid' do
          expect(job.billing_status_name).to eq :over_paid
        end

        context 'when reimbursing the customer' do
          before do
            job.reimburse_payment!
          end

          it 'status should changed to paid' do
            expect(job.billing_status_name).to eq :paid
          end

          it 'customer balance should be zero' do
            expect(job.customer.account.balance).to eq Money.new(0)
          end

          it 'customer reimbursement should equal the paid amount' do
            reimbursement = job.entries.where(type: 'CustomerReimbursement').all
            expect(reimbursement.size).to eq 1
            expect(reimbursement.first.amount).to eq Money.new(100000)
          end
        end

      end

    end

  end

  describe 'when a payment was partially collected and job completed' do
    before do
      collect_a_payment job, amount: 100, type: 'cash'
      start_the_job job
      add_bom_to_job job, cost: 100, price: 1000, quantity: 1
      complete_the_work job
      cancel_the_job job
      job.reload
    end

    it 'status should be changed to canceled' do
      expect(job.status_name).to eq :canceled
    end

    it 'billing status should be collected' do
      expect(job.billing_status_name).to eq :collected
    end

    context 'when depositing the payment' do
      before do
        deposit_all_entries job.payments
        job.reload
      end

      it 'billing status should be over_paid' do
        expect(job.billing_status_name).to eq :over_paid
      end

      context 'when reimbursing the customer' do
        before do
          job.reimburse_payment!
        end

        it 'status should changed to paid' do
          expect(job.billing_status_name).to eq :paid
        end

        it 'customer reimbursement should equal the paid amount' do
          reimbursement = job.entries.where(type: 'CustomerReimbursement').all
          expect(reimbursement.size).to eq 1
          expect(reimbursement.first.amount).to eq Money.new(10000)
        end

      end

    end
  end

  describe 'when one of the payments is rejected' do
    before do
      collect_a_payment job, amount: 100, type: 'cash'
      start_the_job job
      add_bom_to_job job, cost: 100, price: 1000, quantity: 1
      complete_the_work job
      collect_a_payment job, amount: 900, type: 'cheque'
      cancel_the_job job
      job.reload
    end

    it 'billing status should be collected' do
      expect(job.billing_status_name).to eq :collected
    end

    context 'when depositing all payments' do
      before do
        deposit_all_entries job.payments
        job.reload
      end

      it 'billing status should be in_process' do
        expect(job.billing_status_name).to eq :in_process
      end

      context 'when rejecting the cheque payment' do

        before do
          job.payments.last.reject!
          job.reload
        end

        it 'billing status should be over_paid' do
          expect(job.billing_status_name).to eq :over_paid
        end


        context 'when reimbursing the customer' do
          before do
            job.reimburse_payment!
            job.reload
          end

          it 'status should changed to paid' do
            expect(job.billing_status_name).to eq :paid
          end

          it 'customer reimbursement should equal the paid amount' do
            reimbursement = job.entries.where(type: 'CustomerReimbursement').all
            expect(reimbursement.size).to eq 1
            expect(reimbursement.first.amount).to eq Money.new(10000)
          end

        end
      end
    end


  end

  describe 'when the payment is rejected before the job is canceled' do
    before do
      start_the_job job
      add_bom_to_job job, cost: 100, price: 1000, quantity: 1
      complete_the_work job
      collect_a_payment job, amount: 1000, type: 'cheque'
      job.payments.last.deposit!
      job.payments.last.reject!
      cancel_the_job job
      job.reload
    end

    it 'billing status should be paid' do
      expect(job.billing_status_name).to eq :paid
    end
  end

  describe 'when the payment is overdue' do
    context 'when partial cheque payment collected' do
      before do
        start_the_job job
        add_bom_to_job job, cost: 100, price: 1000, quantity: 1
        complete_the_work job
        collect_a_payment job, amount: 100, type: 'cheque'
        job.late_payment!
        cancel_the_job job
        job.reload
      end

      it 'billing status should be collected' do
        expect(job.billing_status_name).to eq :collected
      end

      context 'when depositing and rejecting the cheque payment' do
        before do
          job.payments.last.deposit!
          job.reload
          job.payments.last.reject!
          job.reload
        end

        it 'billing status should be paid' do
          expect(job.billing_status_name).to eq :paid
        end

      end

    end
  end
end
