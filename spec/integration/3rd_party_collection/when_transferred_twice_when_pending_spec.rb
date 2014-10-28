require 'spec_helper'

describe '3rd Party Collection' do

  include_context 'brokered job'

  before do
    accept_the_job subcon_job
    start_the_job subcon_job
    add_bom_to_job subcon_job, cost: 100, price: 1000, quantity: 1
    complete_the_work subcon_job
  end

  context 'when in pending state' do
    before do
      job.reload
      broker_job.reload
    end
    it 'subcon collection status should be pending' do
      expect(job.subcon_collection_status_name).to eq :pending
    end

    it 'subcon collection status should be pending' do
      expect(broker_job.subcon_collection_status_name).to eq :pending
    end

    it 'provider collection status should be pending' do
      expect(broker_job.prov_collection_status_name).to eq :pending
    end

    it 'provider collection status should be pending' do
      expect(subcon_job.prov_collection_status_name).to eq :pending
    end


    context 'when provider collects fully' do
      before do
        job.reload
        collect_full_amount job
        broker_job.reload
        subcon_job.reload
        job.reload
      end

      it 'provider job subcon collection status should be collected' do
        expect(job.subcon_collection_status_name).to eq :pending
      end

      it 'broker subcon collection status should be collected' do
        expect(broker_job.subcon_collection_status_name).to eq :pending
      end

      it 'broker provider collection status should be collected' do
        expect(broker_job.prov_collection_status_name).to eq :pending
      end

      it 'subcon provider collection status should be collected' do
        expect(subcon_job.prov_collection_status_name).to eq :pending
      end

      it 'collection should not be allowed for broker' do
        expect(broker_job.billing_status_events).to eq []
      end

      it 'collection should not be allowed for subcon' do
        expect(subcon_job.billing_status_events).to eq []
      end

    end

    context 'when provider collects partially' do
      before do
        job.reload
        collect_a_payment job, type: 'cash', amount: 10, collector: job.organization
        broker_job.reload
        subcon_job.reload
        job.reload
      end

      it 'provider job subcon collection status should be collected' do
        expect(job.subcon_collection_status_name).to eq :pending
      end

      it 'broker subcon collection status should be collected' do
        expect(broker_job.subcon_collection_status_name).to eq :pending
      end

      it 'broker provider collection status should be collected' do
        expect(broker_job.prov_collection_status_name).to eq :pending
      end

      it 'subcon provider collection status should be collected' do
        expect(subcon_job.prov_collection_status_name).to eq :pending
      end

      it 'collection should not be allowed for broker' do
        expect(broker_job.billing_status_events).to eq [:collect]
      end

      it 'collection should not be allowed for subcon' do
        expect(subcon_job.billing_status_events).to eq [:collect]
      end

    end

    context 'when broker collects fully' do
      before do
        broker_job.reload
        collect_full_amount broker_job
        broker_job.reload
        subcon_job.reload
        job.reload
      end

      it 'provider job subcon collection status should be collected' do
        expect(job.subcon_collection_status_name).to eq :collected
      end

      it 'broker subcon collection status should be collected' do
        expect(broker_job.subcon_collection_status_name).to eq :pending
      end

      it 'broker provider collection status should be collected' do
        expect(broker_job.prov_collection_status_name).to eq :collected
      end

      it 'subcon provider collection status should be collected' do
        expect(subcon_job.prov_collection_status_name).to eq :pending
      end

      it 'collection should not be allowed for broker' do
        expect(broker_job.billing_status_events).to eq []
      end

      it 'collection should not be allowed for subcon' do
        expect(subcon_job.billing_status_events).to eq []
      end

    end

    context 'when broker collects partially' do
      before do
        broker_job.reload
        collect_a_payment broker_job, amount: 10, type: 'credit_card', collector: broker
        broker_job.reload
        subcon_job.reload
        job.reload
      end

      it 'provider job subcon collection status should be partially collected' do
        expect(job.subcon_collection_status_name).to eq :partially_collected
      end

      it 'broker subcon collection status should be pending' do
        expect(broker_job.subcon_collection_status_name).to eq :pending
      end

      it 'broker provider collection status should be partially collected' do
        expect(broker_job.prov_collection_status_name).to eq :partially_collected
      end

      it 'subcon provider collection status should be pending' do
        expect(subcon_job.prov_collection_status_name).to eq :pending
      end

      it 'collection should be allowed for broker' do
        expect(broker_job.billing_status_events).to eq [:collect]
      end

      it 'collection should be allowed for subcon' do
        expect(subcon_job.billing_status_events).to eq [:collect]
      end

    end

    context 'when subcon collects fully' do
      before do
        subcon_job.reload
        collect_full_amount subcon_job
        broker_job.reload
        subcon_job.reload
        job.reload
      end

      it 'provider job subcon collection status should be collected' do
        expect(job.subcon_collection_status_name).to eq :collected
      end

      it 'broker subcon collection status should be collected' do
        expect(broker_job.subcon_collection_status_name).to eq :collected
      end

      it 'broker provider collection status should be collected' do
        expect(broker_job.prov_collection_status_name).to eq :collected
      end

      it 'subcon provider collection status should be collected' do
        expect(subcon_job.prov_collection_status_name).to eq :collected
      end

      it 'collection should not be allowed for broker' do
        expect(broker_job.billing_status_events).to eq []
      end

      it 'collection should not be allowed for subcon' do
        expect(subcon_job.billing_status_events).to eq []
      end

    end

    context 'when subcon collects partially' do
      before do
        broker_job.reload
        collect_a_payment subcon_job, amount: 10, type: 'amex_credit_card', collector: subcon
        broker_job.reload
        subcon_job.reload
        job.reload
      end

      it 'provider job subcon collection status should be partially collected' do
        expect(job.subcon_collection_status_name).to eq :partially_collected
      end

      it 'broker subcon collection status should be partially_collected' do
        expect(broker_job.subcon_collection_status_name).to eq :partially_collected
      end

      it 'broker provider collection status should be partially collected' do
        expect(broker_job.prov_collection_status_name).to eq :partially_collected
      end

      it 'subcon provider collection status should be partially_collected' do
        expect(subcon_job.prov_collection_status_name).to eq :partially_collected
      end

      it 'collection should be allowed for broker' do
        expect(broker_job.billing_status_events).to eq [:collect]
      end

      it 'collection should be allowed for subcon' do
        expect(subcon_job.billing_status_events).to eq [:collect]
      end

    end
  end

  pending 'when using profit split'

end