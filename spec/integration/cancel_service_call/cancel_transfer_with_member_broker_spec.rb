require 'spec_helper'

describe 'Canceling The Transfer With A Broker' do

  include_context 'brokered job'

  before do
    accept_the_job subcon_job
    start_the_job subcon_job
  end

  context 'when broker cancels the transfer' do
    before do
      cancel_the_transfer broker_job
      job.reload
      broker_job.reload
      subcon_job.reload
    end

    it 'prov job billing status should be :pending' do
      expect(job.billing_status_name).to eq :pending
    end

    it 'prov job status should be :transferred' do
      expect(job.status_name).to eq :transferred
    end

    it 'broker job status should be :new' do
      expect(broker_job.status_name).to eq :new
    end

    it 'prov job subcon status should be :pending' do
      expect(job.subcontractor_status_name).to eq :pending
    end

    it 'broker job subcon status should be :na' do
      expect(broker_job.subcontractor_status_name).to eq :na
    end

    it 'subcon job prov status should be :na' do
      expect(subcon_job.provider_status_name).to eq :na
    end

    it 'broker job prov status should be :pending' do
      expect(broker_job.provider_status_name).to eq :pending
    end

    it 'prov job subcon collection status is :pending' do
      expect(job.subcon_collection_status_name).to eq :pending
    end

    it 'broker job subcon collection status is :na' do
      expect(broker_job.subcon_collection_status_name).to eq :na
    end

    it 'subcon job prov collection status is :na' do
      expect(subcon_job.prov_collection_status_name).to eq :na
    end

    it 'prov work status should be :in_progress' do
      expect(job.work_status_name).to eq :in_progress
    end

    it 'broker work status should be :pending' do
      expect(broker_job.work_status_name).to eq :pending
    end

    it 'subcon job work status should be :in_progress' do
      expect(subcon_job.work_status_name).to eq :in_progress
    end

    it 'subcon_job status should be :canceled' do
      expect(subcon_job.status_name).to eq :canceled
    end

    it 'prov should have a cancel_transfer button available' do
      expect(job.status_events).to include :cancel_transfer
    end

    context 'when the prov cancels the transfer the job' do
      before do
        cancel_the_transfer job
        job.reload
        subcon_job.reload
        broker_job.reload
      end

      it 'prov job billing status should be :pending' do
        expect(job.billing_status_name).to eq :pending
      end

      it 'prov job status should be :transferred' do
        expect(job.status_name).to eq :new
      end

      it 'broker job status should be :canceled' do
        expect(broker_job.status_name).to eq :canceled
      end

      it 'prov job subcon status should be :na' do
        expect(job.subcontractor_status_name).to eq :na
      end

      it 'broker job subcon status should be :na' do
        expect(broker_job.subcontractor_status_name).to eq :na
      end

      it 'subcon job prov status should be :na' do
        expect(subcon_job.provider_status_name).to eq :na
      end

      it 'broker job prov status should be :na' do
        expect(broker_job.provider_status_name).to eq :na
      end

      it 'prov job subcon collection status is :na' do
        expect(job.subcon_collection_status_name).to eq :na
      end

      it 'broker job subcon collection status is :na' do
        expect(broker_job.subcon_collection_status_name).to eq :na
      end

      it 'subcon job prov collection status is :na' do
        expect(subcon_job.prov_collection_status_name).to eq :na
      end

      it 'prov work status should be :canceled' do
        expect(job.work_status_name).to eq :pending
      end

      it 'broker work status should be :pending' do
        expect(broker_job.work_status_name).to eq :pending
      end

      it 'subcon job work status should be :in_progress' do
        expect(subcon_job.work_status_name).to eq :in_progress
      end

      it 'subcon_job status should be :canceled' do
        expect(subcon_job.status_name).to eq :canceled
      end

      it 'prov should have the :cancel, :transfer buttons available' do
        expect(job.status_events.sort).to eq [:cancel, :transfer]
      end


      it 'prov should have the :start as work status' do
        expect(job.work_status_events.sort).to eq [:start]
      end


    end

    context 'when the prov cancels the job' do
      before do
        cancel_the_job job
        job.reload
        subcon_job.reload
        broker_job.reload
      end

      it 'prov job billing status should be :pending' do
        expect(job.billing_status_name).to eq :pending
      end

      it 'prov job status should be :transferred' do
        expect(job.status_name).to eq :canceled
      end

      it 'broker job status should be :canceled' do
        expect(broker_job.status_name).to eq :canceled
      end

      it 'prov job subcon status should be :na' do
        expect(job.subcontractor_status_name).to eq :na
      end

      it 'broker job subcon status should be :na' do
        expect(broker_job.subcontractor_status_name).to eq :na
      end

      it 'subcon job prov status should be :na' do
        expect(subcon_job.provider_status_name).to eq :na
      end

      it 'broker job prov status should be :na' do
        expect(broker_job.provider_status_name).to eq :na
      end

      it 'prov job subcon collection status is :na' do
        expect(job.subcon_collection_status_name).to eq :na
      end

      it 'broker job subcon collection status is :na' do
        expect(broker_job.subcon_collection_status_name).to eq :na
      end

      it 'subcon job prov collection status is :na' do
        expect(subcon_job.prov_collection_status_name).to eq :na
      end

      it 'prov work status should be :in_progress' do
        expect(job.work_status_name).to eq :in_progress
      end

      it 'broker work status should be :pending' do
        expect(broker_job.work_status_name).to eq :pending
      end

      it 'subcon job work status should be :in_progress' do
        expect(subcon_job.work_status_name).to eq :in_progress
      end

      it 'subcon_job status should be :canceled' do
        expect(subcon_job.status_name).to eq :canceled
      end

      it 'prov should have the un_cancel button available' do
        expect(job.status_events.sort).to eq [:un_cancel]
      end

      it 'broker should not have the un_cancel button available' do
        expect(broker_job.status_events.sort).to_not include [:un_cancel]
      end

      it 'subcon should not have the un_cancel button available' do
        expect(subcon_job.status_events.sort).to_not include [:un_cancel]
      end

    end


  end

  context 'when prov cancels the transfer job' do
    before do
      cancel_the_transfer job
      job.reload
      broker_job.reload
      subcon_job.reload
    end

    it 'prov job billing status should be :pending' do
      expect(job.billing_status_name).to eq :pending
    end

    it 'prov job status should be :canceled' do
      expect(job.status_name).to eq :new
    end

    it 'broker job status should be :canceled' do
      expect(broker_job.status_name).to eq :canceled
    end

    it 'prov job subcon status should be :na' do
      expect(job.subcontractor_status_name).to eq :na
    end

    it 'broker job subcon status should be :na' do
      expect(broker_job.subcontractor_status_name).to eq :na
    end

    it 'subcon job prov status should be :na' do
      expect(subcon_job.provider_status_name).to eq :na
    end

    it 'broker job prov status should be :na' do
      expect(broker_job.provider_status_name).to eq :na
    end

    it 'prov job subcon collection status is :na' do
      expect(job.subcon_collection_status_name).to eq :na
    end

    it 'broker job subcon collection status is :na' do
      expect(broker_job.subcon_collection_status_name).to eq :na
    end

    it 'subcon job prov collection status is :na' do
      expect(subcon_job.prov_collection_status_name).to eq :na
    end

    it 'prov work status should be :pending' do
      expect(job.work_status_name).to eq :pending
    end

    it 'broker work status should be :in_progress' do
      expect(broker_job.work_status_name).to eq :in_progress
    end

    it 'subcon job work status should be :in_progress' do
      expect(subcon_job.work_status_name).to eq :in_progress
    end

    it 'subcon_job status should be :canceled' do
      expect(subcon_job.status_name).to eq :canceled
    end

  end

  context 'when subcon adds bom, then broker collects and then cancels' do

    before do
      add_bom_to_job subcon_job, cost: 100, price: 1000, buyer: subcon
      collect_a_payment broker_job, amount: 200, type: 'cash', collector: broker
      cancel_the_job broker_job
      job.reload
      subcon_job.reload
      broker_job.reload
    end

    it 'org balance for broker should be 200 (collection)' do
      expect(job.organization.account_for(broker).balance).to eq Money.new(20000)
    end

    it 'broker balance for provider should be zero (collection)' do
      expect(broker_job.organization.account_for(org).balance).to eq Money.new(-20000)
    end

    it 'broker balance for subcon should be 0' do
      expect(broker_job.organization.account_for(subcon).balance).to eq Money.new(0)
    end

    it 'subcon balance for broker should be 0' do
      expect(subcon_job.organization.account_for(broker).balance).to eq Money.new(0)
    end

  end

  context 'when subcon adds bom, then broker collects and prov cancels' do

    before do
      add_bom_to_job subcon_job, cost: 100, price: 1000, buyer: subcon
      collect_a_payment broker_job, amount: 200, type: 'cash', collector: broker
      cancel_the_job job
      job.reload
      subcon_job.reload
      broker_job.reload
    end

    it 'org balance for broker should be 200 (collection)' do
      expect(job.organization.account_for(broker).balance).to eq Money.new(20000)
    end

    it 'broker balance for provider should be zero (collection)' do
      expect(broker_job.organization.account_for(org).balance).to eq Money.new(-20000)
    end

    it 'broker balance for subcon should be 0' do
      expect(broker_job.organization.account_for(subcon).balance).to eq Money.new(0)
    end

    it 'subcon balance for broker should be 0' do
      expect(subcon_job.organization.account_for(broker).balance).to eq Money.new(0)
    end

  end

  context 'when broker adds bom, then the subcon collects and prov cancels' do

    before do
      add_bom_to_job subcon_job, cost: 100, price: 1000, buyer: subcon
      collect_a_payment broker_job, amount: 200, type: 'cash', collector: broker
    end

    it 'org balance for broker should be 200 (collection)' do
      expect(job.organization.account_for(broker).balance).to eq Money.new(20200)
    end

    it 'broker balance for provider should be zero (collection)' do
      expect(broker_job.organization.account_for(org).balance).to eq Money.new(-20200)
    end

    it 'broker balance for subcon should be 0' do
      expect(broker_job.organization.account_for(subcon).balance).to eq Money.new(200)
    end

    it 'subcon balance for broker should be 0' do
      expect(subcon_job.organization.account_for(broker).balance).to eq Money.new(-200)
    end


    context 'when prov cancels' do

      before do
        cancel_the_job job
        job.reload
        subcon_job.reload
        broker_job.reload
      end

      it 'org balance for broker should be 200 (collection)' do
        expect(job.organization.account_for(broker).balance).to eq Money.new(20000)
      end

      it 'broker balance for provider should be zero (collection)' do
        expect(broker_job.organization.account_for(org).balance).to eq Money.new(-20000)
      end

      it 'broker balance for subcon should be 0' do
        expect(broker_job.organization.account_for(subcon).balance).to eq Money.new(0)
      end

      it 'subcon balance for broker should be 0' do
        expect(subcon_job.organization.account_for(broker).balance).to eq Money.new(0)
      end
    end

  end


end