require 'spec_helper'

shared_context 'when late' do

  before do
    job.late_payment!
  end

  it 'billing status should be overdue' do
    expect(job.billing_status_name).to eq :overdue
  end

end

shared_context 'after collecting the full amount' do
  before do
    collect_full_amount subcon_job
    job.reload
  end

  it 'billing status should be collected' do
    expect(job.billing_status_name).to eq :collected
  end

  it 'subcon collection status should be collected' do
    expect(job.subcon_collection_status_name).to eq :collected
  end

  it 'provider collection status should be collected' do
    expect(subcon_job.reload.prov_collection_status_name).to eq :collected
  end


end

describe 'Customer Billing When Provider Transfers To Member' do

  include_context 'transferred job'

  before do
    transfer_the_job
  end

  context 'before the job is accepted by the subcon' do

    it 'should not allow a collection for the subcon' do
      expect(subcon_job.billing_status_events).to_not include(:collect)
    end

    it 'should allow a collection for the provider' do
      expect(job.billing_status_events).to include(:collect)
    end
  end

  context 'when the job is accepted by the subcon' do

    before do
      accept_the_job subcon_job
    end

    it 'should  allow a collection for the subcon and provider' do
      expect(subcon_job.billing_status_events).to eq [:collect]
      expect(job.reload.billing_status_events).to include(:collect)
    end


    context 'when starting the job' do
      before do
        start_the_job subcon_job
        add_bom_to_job subcon_job, cost: '100', price: '1000', quantity: '1'
      end

      context 'before the job is done' do

        context 'subcon collects cash for the full amount' do
          before do
            collect_a_payment subcon_job, amount: '1000', type: 'cash', collector: job.subcontractor
            job.reload
            subcon_job.reload
          end

          it 'billing status should be partially_collected' do
            expect(job.billing_status_name).to eq :partially_collected
          end

          it 'subcon collection status should be partially_collected' do
            expect(job.subcon_collection_status_name).to eq :partially_collected
          end

          it 'prov collection status should be partially_collected' do
            expect(subcon_job.prov_collection_status_name).to eq :partially_collected
          end


          context 'when completing the job (and invoking the payment)' do
            before do
              complete_the_work subcon_job
            end

            it 'billing status should be collected' do
              expect(job.reload.billing_status_name).to eq :collected
            end

            it 'subcon collection status should be collected' do
              expect(job.reload.subcon_collection_status_name).to eq :collected
            end

            it 'prov collection status should be collected' do
              expect(subcon_job.reload.prov_collection_status_name).to eq :collected
            end


          end
        end

      end

      context 'after the job is done' do

        before do
          complete_the_work subcon_job
        end

        describe 'collecting the full amount by the subcon' do

          let(:collection_job) { subcon_job }
          let(:collector) { subcon }
          let(:billing_status) { :na }        # since the job is not done it is set to partial
          let(:billing_status_4_cash) { :na } # since the job is not done it is set to partial
          let(:subcon_collection_status) { nil }
          let(:subcon_collection_status_4_cash) { nil }
          let(:prov_collection_status) { :collected }
          let(:prov_collection_status_4_cash) { :collected }

          let(:customer_balance_before_payment) { 1000 }
          let(:payment_amount) { 1000 }
          let(:job_events) { [ServiceCallReceivedEvent,
                              ServiceCallAcceptEvent,
                              ServiceCallStartEvent,
                              ServiceCallCompleteEvent,
                              ScCollectEvent] }
          let(:the_prov_job) { job.reload }
          let(:the_billing_status) { :collected }
          let(:the_subcon_collection_status) { :collected }

          include_examples 'successful customer payment collection'
        end


      end
    end
  end

  context 'when in pending state' do

    it 'billing events should be :collect, :late' do
      expect(job.billing_status_events.sort).to eq [:collect, :late]
    end

    describe 'when payment is late' do
      include_context 'when late'
    end

    describe 'collect' do
      context 'when collecting partial amount' do
        let(:collection_job) { job }
        let(:collector) { org }
        let(:billing_status) { :partially_collected }        # since the job is not done it is set to partial
        let(:billing_status_4_cash) { :partially_collected } # since the job is not done it is set to partial
        let(:subcon_collection_status) { :pending }
        let(:subcon_collection_status_4_cash) { :pending }
        let(:prov_collection_status) { nil }
        let(:prov_collection_status_4_cash) { nil }

        let(:customer_balance_before_payment) { 0 }
        let(:payment_amount) { 10 }
        let(:job_events) { [ScCollectEvent, ServiceCallTransferEvent] }
        let(:the_prov_job) { nil }
        let(:the_billing_status) { nil }
        let(:the_subcon_collection_status) { nil }

        include_examples 'successful customer payment collection'

        context 'when collecting the full amount after partial collection' do

          before do
            accept_the_job subcon_job
            start_the_job subcon_job
            collect_a_payment job, amount: 10
            add_bom_to_job subcon_job, cost: '100', price: '1000', quantity: '1'
            complete_the_work subcon_job
            job.reload
          end


          let(:collection_job) { subcon_job }
          let(:collector) { subcon }
          let(:billing_status) { :na }        # since the job is not done it is set to partial
          let(:billing_status_4_cash) { :na } # since the job is not done it is set to partial
          let(:subcon_collection_status) { nil }
          let(:subcon_collection_status_4_cash) { nil }
          let(:prov_collection_status) { :collected }
          let(:prov_collection_status_4_cash) { :collected }

          let(:customer_balance_before_payment) { 990 }
          let(:payment_amount) { 990 }
          let(:job_events) { [ScCollectEvent, ScProviderCollectedEvent, ServiceCallReceivedEvent, ServiceCallAcceptEvent, ServiceCallCompleteEvent, ServiceCallStartEvent] }
          let(:the_prov_job) { job.reload }
          let(:the_billing_status) { :collected }
          let(:the_subcon_collection_status) { :collected }

          include_examples 'successful customer payment collection'

        end

      end

      context 'when collecting the full amount' do

        before do
          accept_the_job subcon_job
          start_the_job subcon_job
          add_bom_to_job subcon_job, cost: '100', price: '1000', quantity: '1'
          complete_the_work subcon_job
          collect_a_payment job, amount: 10, type: 'cheque'
          subcon_job.reload
        end

        # bug in transferred service call #payment_entries (when it is a mixed entry it doesn't go to collected)
        let(:collection_job) { subcon_job }
        let(:collector) { subcon }
        let(:billing_status) { :na }        # since the job is not done it is set to partial
        let(:billing_status_4_cash) { :na } # since the job is not done it is set to partial
        let(:subcon_collection_status) { nil }
        let(:subcon_collection_status_4_cash) { nil }
        let(:prov_collection_status) { :collected }
        let(:prov_collection_status_4_cash) { :collected }

        let(:customer_balance_before_payment) { 990 }
        let(:payment_amount) { 990 }
        let(:job_events) { [ScCollectEvent, ScProviderCollectedEvent, ServiceCallAcceptEvent, ServiceCallCompleteEvent, ServiceCallReceivedEvent, ServiceCallStartEvent ] }
        let(:the_prov_job) { job.reload }
        let(:the_billing_status) { :collected }
        let(:the_subcon_collection_status) { :collected }

        include_examples 'successful customer payment collection'

      end

    end

  end

  context 'when in partially collected state' do
    before do
      accept_the_job subcon_job
      start_the_job subcon_job
      add_bom_to_job subcon_job, cost: 100, price: 1000, quantity: 1
      collect_a_payment subcon_job, amount: 100, type: 'cash', collector: subcon
    end
    it 'billing status should be partially_collected' do
      expect(job.reload.billing_status_name).to eq :partially_collected
    end

    it 'billing events should be :collect, :late' do
      expect(job.reload.billing_status_events.sort).to eq [:collect, :late]
    end

    describe 'when payment is late' do
      include_context 'when late'
    end
    describe 'collect'
  end

  context 'when in overdue state' do
    include_context 'when late'

    it 'billing events should be :collect' do
      expect(job.billing_status_events.sort).to eq [:collect]
    end

    context 'when collecting partial amount' do
      let(:collection_job) { job }
      let(:collector) { org }
      let(:billing_status) { :overdue }        # since the job is not done it is set to partial
      let(:billing_status_4_cash) { :overdue } # since the job is not done it is set to partial
      let(:subcon_collection_status) { :pending }
      let(:subcon_collection_status_4_cash) { :pending }
      let(:prov_collection_status) { nil }
      let(:prov_collection_status_4_cash) { nil }

      let(:customer_balance_before_payment) { 0 }
      let(:payment_amount) { 10 }
      let(:job_events) { [ScCollectEvent, ScPaymentOverdueEvent, ServiceCallTransferEvent] }
      let(:the_prov_job) { nil }
      let(:the_billing_status) { nil }
      let(:the_subcon_collection_status) { nil }

      include_examples 'successful customer payment collection'

      context 'when collecting the full amount' do
        let(:collection_job) { job }
        let(:collector) { org }
        let(:billing_status) { :overdue }        # since the job is not done it is set to partial
        let(:billing_status_4_cash) { :overdue } # since the job is not done it is set to partial
        let(:subcon_collection_status) { :pending }
        let(:subcon_collection_status_4_cash) { :pending }
        let(:prov_collection_status) { nil }
        let(:prov_collection_status_4_cash) { nil }

        let(:customer_balance_before_payment) { 0 }
        let(:payment_amount) { 10 }
        let(:job_events) { [ScCollectEvent, ScPaymentOverdueEvent, ServiceCallTransferEvent] }
        let(:the_prov_job) { nil }
        let(:the_billing_status) { nil }
        let(:the_subcon_collection_status) { nil }

        include_examples 'successful customer payment collection'

      end
    end

    context 'when collecting the full amount' do

      before do
        accept_the_job subcon_job
        start_the_job subcon_job
        add_bom_to_job subcon_job, cost: '100', price: '1000', quantity: '1'
        complete_the_work subcon_job
      end

      let(:collection_job) { subcon_job }
      let(:collector) { subcon }
      let(:billing_status) { :na }        # since the job is not done it is set to partial
      let(:billing_status_4_cash) { :na } # since the job is not done it is set to partial
      let(:subcon_collection_status) { nil }
      let(:subcon_collection_status_4_cash) { nil }
      let(:prov_collection_status) { :collected }
      let(:prov_collection_status_4_cash) { :collected }

      let(:customer_balance_before_payment) { 1000 }
      let(:payment_amount) { 1000 }
      let(:job_events) { [ScCollectEvent, ServiceCallAcceptEvent, ServiceCallReceivedEvent, ServiceCallStartEvent, ServiceCallCompleteEvent] }
      let(:the_prov_job) { job.reload }
      let(:the_billing_status) { :collected }
      let(:the_subcon_collection_status) { :collected }


      include_examples 'successful customer payment collection'


      describe 'after collecting the full amount' do
        include_context 'after collecting the full amount'
      end


    end

  end

  context 'when in collected state' do
    before do
      accept_the_job subcon_job
      start_the_job subcon_job
      add_bom_to_job subcon_job, cost: 100, price: 1000, quantity: 1
      complete_the_work subcon_job
    end

    context 'when collected by the subcon' do
      before do
        collect_a_payment subcon_job, type: 'cash', amount: 1000
      end
      it 'billing status should be collected' do
        expect(job.reload.billing_status_name).to eq :collected
      end

      it 'billing events should be :deposit' do
        expect(job.reload.billing_status_events.sort).to eq [:deposited]
      end

      describe 'when fully deposited'
      describe 'when all cash and overpaid'
      describe 'when all cash and fully paid'
    end
  end

  context 'when in in process state' do
    before do
      accept_the_job subcon_job
      start_the_job subcon_job
      add_bom_to_job subcon_job, cost: 100, price: 1000, quantity: 1
      complete_the_work subcon_job
      collect_a_payment subcon_job, type: 'cheque', amount: 1000
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

      describe 'when payment is rejected' do
        before do
          entry.reject!
        end
        it 'billing status should be rejected' do
          expect(job.reload.billing_status_name).to eq :rejected
        end

      end
      describe 'when payment is cleared' do
        before do
          entry.clear!
        end

        it 'billing status should be paid' do
          expect(job.reload.billing_status_name).to eq :paid
        end

      end


    end

  end

  context 'when in overpaid state' do
    before do
      accept_the_job subcon_job
      start_the_job subcon_job
      add_bom_to_job subcon_job, cost: 100, price: 1000, quantity: 1
      collect_a_payment subcon_job, type: 'cash', amount: 1100
      complete_the_work subcon_job
      job.payments.sort.last.deposit!
    end

    it 'billing events should be :reimburse' do
      expect(job.reload.billing_status_events.sort).to eq [:reimburse]
    end

    describe 'reimbursement' do
      before do
        job.reload.reimburse_payment!
      end
       it 'billing status should be paid' do
         expect(job.billing_status_name).to eq :paid
       end

    end

  end

  context 'when in rejected state' do
    it 'billing events should be :collect, :late' do
      expect(job.billing_status_events.sort).to eq [:collect, :late]
    end

    describe 'when payment collected'
    describe 'when payment is late'
  end

  context 'when in paid state' do
    it 'there should be no billing events' do
      expect(job.billing_status_events.sort).to eq []
    end

  end

end