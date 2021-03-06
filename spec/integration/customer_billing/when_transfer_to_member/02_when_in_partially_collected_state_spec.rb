require 'spec_helper'

describe 'Billing when in partially collected state' do

  include_context 'transferred job'

  before do
    transfer_the_job
    accept_the_job subcon_job
    start_the_job subcon_job
    add_bom_to_job subcon_job, cost: 100, price: 1000, quantity: 1
    collect_a_payment subcon_job, amount: 100, type: 'cash', collector: subcon
  end


  it 'billing status should be partially_collected' do
    expect(job.reload.billing_status_name).to eq :partially_collected
  end

  it 'billing events should be [:cancel, :collect, :late, :reject, :reopen]' do
    expect(job.reload.billing_status_events.sort).to eq [:cancel, :collect, :late, :reject, :reopen]
  end

  it 'prov not should be able to deposit the customer payment before subcon deposits with the prov' do
    expect(job.payments.last.allowed_status_events).to eq []
  end

  context 'when subcon deposits the payment' do
    before do
      subcon_job.collection_entries.last.deposit!
      job.reload
    end

    it 'prov should be able to deposit the customer payment before subcon deposits with the prov' do
      expect(job.payments.last.allowed_status_events).to eq [:deposit]
    end

    context 'when the prov confirms the deposit' do
      before do
        job.deposited_entries.last.confirm!
        job.reload
      end

      it 'prov should be able to deposit the customer payment before subcon deposits with the prov' do
        expect(job.payments.last.allowed_status_events).to eq [:deposit]
      end

    end

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
        let(:the_prov_job) { job.reload }
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