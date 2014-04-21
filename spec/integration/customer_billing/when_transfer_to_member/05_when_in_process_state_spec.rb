require 'spec_helper'

describe 'Billing when in process state' do

  include_context 'transferred job'

  before do
    transfer_the_job
    accept_the_job subcon_job
    start_the_job subcon_job
    add_bom_to_job subcon_job, cost: 100, price: 1000, quantity: 1
    complete_the_work subcon_job
    job.reload
  end

  context 'when collecting single payment by the subcon' do

    before do
      collect_a_payment subcon_job, type: 'cheque', amount: 1000
    end

    it 'subcon balance should match provider balance' do
      expect(job.subcon_balance + subcon_job.provider_balance).to eq Money.new(0)
    end


    include_context 'deposit payment' do
      let(:entry) { job.payments.sort.last }
      let(:status) { :deposited }
      let(:available_events) { [:clear, :reject] }

      it 'billing events should be :reject, :clear' do
        expect(job.reload.billing_status_events.sort).to eq [:reject]
      end

      it 'billing status should be paid' do
        expect(job.reload.billing_status_name).to eq :in_process
      end

      it 'subcon balance should match provider balance' do
        expect(job.subcon_balance + subcon_job.provider_balance).to eq Money.new(0)
      end


      describe 'when payment is rejected' do
        before do
          entry.reject!
        end
        it 'billing status should be rejected' do
          expect(job.reload.billing_status_name).to eq :rejected
        end

        it 'subcon balance should match provider balance' do
          expect(job.subcon_balance + subcon_job.provider_balance).to eq Money.new(0)
        end

      end
      describe 'when payment is cleared' do
        before do
          entry.clear!
        end

        it 'billing status should be paid' do
          expect(job.reload.billing_status_name).to eq :paid
        end

        it 'subcon balance should match provider balance' do
          expect(job.subcon_balance + subcon_job.provider_balance).to eq Money.new(0)
        end

      end


    end

  end

  context 'when collecting credit card and cash' do

    let(:cash_payment) {job.payments.where(type: 'CashPayment').first}
    let(:credit_payment) {job.payments.where(type: 'CreditPayment').first}

    before do
      collect_a_payment job, type: 'credit_card', amount: 500
      collect_a_payment job, type: 'cash', amount: 500
    end

    context 'when depositing the credit card payment' do
      before do
        credit_payment.deposit!
        job.reload
      end

      it 'billing status should be in_process' do
        expect(job.billing_status_name).to eq :in_process
      end
      
      context 'when clearing the credit card payment' do
        
        context 'when the cash payment already deposited' do
          before do
            cash_payment.deposit!
            job.reload
          end
          
          it 'billing status should be in_process' do
            expect(job.billing_status_name).to eq :in_process
          end

          describe 'clearing the credit card' do
            before do
              credit_payment.clear!
              job.reload
            end

            it 'billing status should be paid' do
              expect(job.billing_status_name).to eq :paid
            end

          end
          
        end
        
        context 'when the cash payment was not deposited yet' do
          before do
            credit_payment.clear!
            job.reload
          end
          
          it 'billing status should be in_process' do
            expect(job.billing_status_name).to eq :in_process
          end

          context 'when depositing the cash payment' do
            before do
              cash_payment.deposit!
              job.reload
            end

            it 'billing status should be paid' do
              expect(job.billing_status_name).to eq :paid
            end

          end
          
        end
      end

    end
  end

  context 'when over paid' do

    let(:cash_payment) {job.payments.where(type: 'CashPayment').first}
    let(:credit_payment) {job.payments.where(type: 'CreditPayment').first}

    before do
      collect_a_payment job, type: 'credit_card', amount: 500
      collect_a_payment job, type: 'cash', amount: 600
    end

    context 'when depositing the credit card payment' do
      before do
        credit_payment.deposit!
        job.reload
      end

      it 'billing status should be in_process' do
        expect(job.billing_status_name).to eq :in_process
      end

      context 'when clearing the credit card payment' do

        context 'when the cash payment already deposited' do
          before do
            cash_payment.deposit!
            job.reload
          end

          it 'billing status should be in_process' do
            expect(job.billing_status_name).to eq :in_process
          end

          describe 'clearing the credit card' do
            before do
              credit_payment.clear!
              job.reload
            end

            it 'billing status should be paid' do
              expect(job.billing_status_name).to eq :over_paid
            end

          end

        end

        context 'when the cash payment was not deposited yet' do
          before do
            credit_payment.clear!
            job.reload
          end

          it 'billing status should be in_process' do
            expect(job.billing_status_name).to eq :in_process
          end

          context 'when depositing the cash payment' do
            before do
              cash_payment.deposit!
              job.reload
            end

            it 'billing status should be paid' do
              expect(job.billing_status_name).to eq :over_paid
            end

          end

        end
      end

    end

  end


end