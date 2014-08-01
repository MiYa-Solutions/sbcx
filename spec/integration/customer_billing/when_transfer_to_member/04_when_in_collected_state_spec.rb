require 'spec_helper'

describe 'Billing when in collected state' do

  include_context 'transferred job'

  before do
    transfer_the_job
    accept_the_job subcon_job
    start_the_job subcon_job
    add_bom_to_job subcon_job, cost: 100, price: 1000, quantity: 1
    complete_the_work subcon_job
    job.reload
  end


  context 'when collected by the subcon' do

    context 'when collecting only cash' do
      before do
        collect_a_payment subcon_job, type: 'cash', amount: 1000
      end

      it 'subcon balance should match provider balance' do
        expect(job.subcon_balance + subcon_job.provider_balance).to eq Money.new(0)
      end

      it 'billing status should be collected' do
        expect(job.reload.billing_status_name).to eq :collected
      end

      it 'billing events should be :deposited' do
        expect(job.reload.billing_status_events.sort).to eq [:deposited]
      end

      it 'deposit should not be allowed for user' do
        expect(event_permitted_for_job?('billing_status', 'deposited', user, job)).to be_false
      end

      it 'the corresponding payment should not allow to deposit before subcon marks as deposited' do
        expect(job.reload.payments.last.allowed_status_events).to eq []
      end


      context 'when fully deposited to provider' do
        before do
          deposit_all_entries subcon_job.collection_entries
        end

        it 'the corresponding payment should now allow to deposit clear and reject as the subcon marked collection as deposited' do
          expect(job.reload.payments.last.allowed_status_events.sort).to eq [:deposit]
        end

        it 'billing status should be in_process' do
          expect(job.reload.billing_status_name).to eq :collected
        end

        context 'when depositing customer payments' do
          before do
            deposit_all_entries job.payments
            job.reload
          end

          it 'billing status should be paid' do
            expect(job.billing_status_name).to eq :paid
          end

        end


      end
    end

    context 'when collecting mixed cash and credit' do

      before do
        collect_a_payment subcon_job, type: 'cash', amount: 500
        collect_a_payment subcon_job, type: 'credit_card', amount: 500
      end
      it 'subcon balance should match provider balance' do
        expect(job.subcon_balance + subcon_job.provider_balance).to eq Money.new(0)
      end

      it 'billing status should be collected' do
        expect(job.reload.billing_status_name).to eq :collected
      end

      context 'when fully deposited to provider' do
        before do
          deposit_all_entries subcon_job.collection_entries
        end

        it 'the corresponding payment should now allow to deposit as the subcon marked collection as deposited' do
          expect(job.reload.payments.last.allowed_status_events.sort).to eq [:deposit]
        end

        it 'billing status should be in_process' do
          expect(job.reload.billing_status_name).to eq :collected
        end

        context 'when depositing customer payments' do
          before do
            deposit_all_entries job.payments
            job.reload
          end

          it 'billing status should be in process' do
            expect(job.billing_status_name).to eq :in_process
          end

        end


      end


    end

    context 'when all cash and overpaid' do

      before do
        collect_a_payment subcon_job, type: 'cash', amount: 1100
      end

      it 'subcon balance should match provider balance' do
        expect(job.subcon_balance + subcon_job.provider_balance).to eq Money.new(0)
      end

      it 'billing status should be collected' do
        expect(job.reload.billing_status_name).to eq :collected
      end

      context 'when fully deposited to provider' do
        before do
          deposit_all_entries subcon_job.collection_entries
        end

        it 'the corresponding payment should now allow to deposit the payment as the subcon marked collection as deposited' do
          expect(job.reload.payments.last.allowed_status_events.sort).to eq [:deposit]
        end

        it 'billing status should be in_process' do
          expect(job.reload.billing_status_name).to eq :collected
        end

        context 'when depositing customer payments' do
          before do
            deposit_all_entries job.payments
            job.reload
          end

          it 'billing status should be paid' do
            expect(job.billing_status_name).to eq :over_paid
          end

        end


      end

    end

  end

  context 'when collected by provider' do

    context 'when collecting only cash' do
      before do
        collect_a_payment job, type: 'cash', amount: 1000
      end

      it 'subcon balance should match provider balance' do
        expect(job.subcon_balance + subcon_job.provider_balance).to eq Money.new(0)
      end

      it 'billing status should be collected' do
        expect(job.reload.billing_status_name).to eq :collected
      end

      it 'billing events should be :deposited' do
        expect(job.reload.billing_status_events.sort).to eq [:deposited]
      end

      it 'deposited should not be allowed for user' do
        expect(event_permitted_for_job?('billing_status', 'deposited', user, job)).to be_false
      end


      it 'the corresponding payment should allow to deposit the payment as this was collected but the provider' do
        expect(job.reload.payments.last.allowed_status_events.sort).to eq [:deposit]
      end

      it 'billing status should be collected' do
        expect(job.reload.billing_status_name).to eq :collected
      end

      context 'when depositing customer payments' do
        before do
          deposit_all_entries job.payments
          job.reload
        end

        it 'billing status should be paid' do
          expect(job.billing_status_name).to eq :paid
        end

      end


    end

    context 'when collecting mixed cash and credit' do

      before do
        collect_a_payment subcon_job, type: 'cash', amount: 500
        collect_a_payment subcon_job, type: 'credit_card', amount: 500
      end
      it 'subcon balance should match provider balance' do
        expect(job.subcon_balance + subcon_job.provider_balance).to eq Money.new(0)
      end

      it 'billing status should be collected' do
        expect(job.reload.billing_status_name).to eq :collected
      end

      context 'when fully deposited to provider' do
        before do
          deposit_all_entries subcon_job.collection_entries
        end

        it 'the corresponding payment should now allow to deposit the payment as the subcon marked collection as deposited' do
          expect(job.reload.payments.last.allowed_status_events.sort).to eq [:deposit]
        end

        it 'billing status should be in_process' do
          expect(job.reload.billing_status_name).to eq :collected
        end

        context 'when depositing customer payments' do
          before do
            deposit_all_entries job.payments
            job.reload
          end

          it 'billing status should be in process' do
            expect(job.billing_status_name).to eq :in_process
          end

        end


      end


    end

    context 'when all cash and overpaid' do

      before do
        collect_a_payment subcon_job, type: 'cash', amount: 1100
      end

      it 'subcon balance should match provider balance' do
        expect(job.subcon_balance + subcon_job.provider_balance).to eq Money.new(0)
      end

      it 'billing status should be collected' do
        expect(job.reload.billing_status_name).to eq :collected
      end

      context 'when fully deposited to provider' do
        before do
          deposit_all_entries subcon_job.collection_entries
        end

        it 'the corresponding payment should now allow to deposit as the subcon marked collection as deposited' do
          expect(job.reload.payments.last.allowed_status_events.sort).to eq [:deposit]
        end

        it 'billing status should be in_process' do
          expect(job.reload.billing_status_name).to eq :collected
        end

        context 'when depositing customer payments' do
          before do
            deposit_all_entries job.payments
            job.reload
          end

          it 'billing status should be paid' do
            expect(job.billing_status_name).to eq :over_paid
          end

        end


      end

    end

  end

  context 'when both provider and subcon collected' do
    context 'when collecting cash' do
      before do
        collect_a_payment job, type: 'cash', amount: 500
        collect_a_payment subcon_job, type: 'cash', amount: 500
        job.reload
        subcon_job.reload
      end

      it 'subcon balance should match provider balance' do
        expect(job.subcon_balance + subcon_job.provider_balance).to eq Money.new(0)
      end

      it 'billing status should be collected' do
        expect(job.billing_status_name).to eq :collected
      end

      it 'the provider collected payment should allow to deposit clear and reject ' do
        expect(job.payments.first.allowed_status_events.sort).to eq [:deposit]
      end

      it 'the subcon collected payment should not allow to deposit clear and reject ' do
        expect(job.payments.last.allowed_status_events.sort).to eq []
      end


    end
  end


end