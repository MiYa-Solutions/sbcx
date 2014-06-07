require 'spec_helper'

describe 'Billing when broker involved and in partially collected state' do

  include_context 'brokered job'

  before do
    accept_the_job subcon_job
    start_the_job subcon_job
    add_bom_to_job subcon_job, cost: 100, price: 1000, quantity: 1
    collect_a_payment subcon_job, amount: 100, type: 'cash', collector: subcon
  end

  it 'all jobs created' do
    expect(subcon_job).to be_instance_of(SubconServiceCall)
    expect(broker_job).to be_instance_of(BrokerServiceCall)
    expect(job).to be_instance_of(MyServiceCall)
  end


  it 'billing status should be partially_collected' do
    expect(job.reload.billing_status_name).to eq :partially_collected
  end

  it 'billing events should be :collect, :late' do
    expect(job.reload.billing_status_events.sort).to eq [:collect, :late, :reject]
  end

  describe 'when payment is late' do
    include_context 'when late'
  end

  describe 'collect' do

    context 'when the broker collects the payment' do
      let(:collection_job) { broker_job }
      let(:collector) { broker }
      let(:billing_status) { :na }        # since the job is not done it is set to partial
      let(:billing_status_4_cash) { :na } # since the job is not done it is set to partial
      let(:subcon_collection_status) { :partially_collected }
      let(:subcon_collection_status_4_cash) { :partially_collected }
      let(:prov_collection_status) { :partially_collected }
      let(:prov_collection_status_4_cash) { :partially_collected }

      let(:customer_balance_before_payment) { -100 }
      let(:payment_amount) { 10 }
      let(:job_events) { [ServiceCallReceivedEvent, ScCollectEvent, ScCollectedEvent, ServiceCallAcceptEvent, ServiceCallTransferEvent, ServiceCallAcceptedEvent, ServiceCallStartedEvent] }
      let(:the_prov_job) { job }
      let(:the_billing_status) { :partially_collected}
      let(:the_subcon_collection_status) { :partially_collected }

      include_examples 'successful customer payment collection'

    end

    context 'when collecting partial amount' do
      let(:collection_job) { job }
      let(:collector) { org }
      let(:billing_status) { :partially_collected }        # since the job is not done it is set to partial
      let(:billing_status_4_cash) { :partially_collected } # since the job is not done it is set to partial
      let(:subcon_collection_status) { :partially_collected }
      let(:subcon_collection_status_4_cash) { :partially_collected }
      let(:prov_collection_status) { nil }
      let(:prov_collection_status_4_cash) { nil }

      let(:customer_balance_before_payment) { -100 }
      let(:payment_amount) { 10 }
      let(:job_events) { [ScCollectEvent, ScCollectedEvent, ServiceCallTransferEvent, ServiceCallAcceptedEvent, ServiceCallStartedEvent] }
      let(:the_prov_job) { nil }
      let(:the_billing_status) { nil }
      let(:the_subcon_collection_status) { nil }

      include_examples 'successful customer payment collection'

    end

    context 'when collecting the full amount' do

      describe 'after the job is done' do
        before do
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

        let(:customer_balance_before_payment) { 900 }
        let(:payment_amount) { 900 }
        let(:job_events) { [ScCollectEvent, ScCollectEvent, ServiceCallAcceptEvent, ServiceCallCompleteEvent, ServiceCallReceivedEvent, ServiceCallStartEvent] }
        let(:the_prov_job) { broker_job.reload }
        let(:the_billing_status) { :collected }
        let(:the_subcon_collection_status) { :collected }

        include_examples 'successful customer payment collection'

        describe 'job billing status' do
          include_context 'after collecting the full amount'
        end
      end


    end

  end


end