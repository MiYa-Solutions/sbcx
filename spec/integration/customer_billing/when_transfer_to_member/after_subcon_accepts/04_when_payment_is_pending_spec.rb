require 'spec_helper'


describe 'When payment was not collected yet' do

  include_context 'transferred job'

  before do
    transfer_the_job
    accept_the_job subcon_job
  end


  it 'billing status should be pending' do
    expect(job.billing_status_name).to eq :pending
  end

  it 'billing events should be [:collect, :late, :reopen]' do
    expect(job.billing_status_events.sort).to eq [:collect, :late, :reopen]
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
      let(:job_events) { [ScCollectEvent, ServiceCallTransferEvent, ServiceCallAcceptedEvent] }
      let(:the_prov_job) { nil }
      let(:the_billing_status) { nil }
      let(:the_subcon_collection_status) { nil }

      include_examples 'successful customer payment collection'

      context 'when collecting the full amount after partial collection' do

        before do
          start_the_job subcon_job
          collect_a_payment job, amount: 10
          add_bom_to_job subcon_job, cost: '100', price: '1000', quantity: '1'
          complete_the_work subcon_job
          job.reload
        end

        it 'subcon balance should match provider balance' do
          expect(job.subcon_balance + subcon_job.provider_balance).to eq Money.new(0)
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
        start_the_job subcon_job
        add_bom_to_job subcon_job, cost: '100', price: '1000', quantity: '1'
        complete_the_work subcon_job
        collect_a_payment job, amount: 10, type: 'cheque'
        subcon_job.reload
      end

      it 'subcon balance should match provider balance' do
        expect(job.subcon_balance + subcon_job.provider_balance).to eq Money.new(0)
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
      let(:job_events) { [ScCollectEvent, ScProviderCollectedEvent, ServiceCallAcceptEvent, ServiceCallCompleteEvent, ServiceCallReceivedEvent, ServiceCallStartEvent] }
      let(:the_prov_job) { job.reload }
      let(:the_billing_status) { :collected }
      let(:the_subcon_collection_status) { :collected }

      include_examples 'successful customer payment collection'

    end

  end


end