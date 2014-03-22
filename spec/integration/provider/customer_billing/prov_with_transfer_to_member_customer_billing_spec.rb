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
    expect(subcon_job.provider_collection_status_name).to eq :collected
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
  end

  context 'when the job is accepted by the subcon' do

    before do
      accept_the_job subcon_job
    end

    it 'should  allow a collection for the subcon' do
      expect(subcon_job.billing_status_events).to eq [:collect]
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

  context 'when pending' do

    it 'billing events should be :collect, :late' do
      expect(job.billing_status_events.sort).to eq [:collect, :late]
    end

    include_context 'when late' do

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

        include_context 'after collecting the full amount'


      end

    end

    context 'when collecting partial amount' do

      context 'when collecting partial amount' do

      end

      context 'when collecting the full amount' do

      end

      context 'when late' do

      end
    end

    context 'when collecting the full amount' do

      context 'when payment is deposited' do

        context 'when rejecting the payment' do

        end

        context 'when clearing the payment' do

        end

      end

    end

    context 'when collecting too much' do

      context 'when collecting all cash' do

        context 'when payment is deposited' do

          context 'when rejecting the payment' do

          end

          context 'when clearing the payment' do

          end
        end

      end

      context 'when collecting none cash' do

        context 'when payment is deposited' do

          context 'when rejecting the payment' do

          end

          context 'when clearing the payment' do

          end
        end

      end
    end
  end
end