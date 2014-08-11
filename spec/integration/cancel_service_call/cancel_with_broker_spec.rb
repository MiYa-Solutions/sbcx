require 'spec_helper'

describe 'Canceling Job With A Broker' do

  include_context 'brokered job'

  before do
    accept_the_job subcon_job
    start_the_job subcon_job
  end


  context 'when subcon cancels the job' do
    before do
      cancel_the_job subcon_job
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

    it 'broker job status should be :transferred' do
      expect(broker_job.status_name).to eq :transferred
    end

    it 'prov job subcon status should be :pending' do
      expect(job.subcontractor_status_name).to eq :pending
    end

    it 'broker job subcon status should be :pending' do
      expect(broker_job.subcontractor_status_name).to eq :pending
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

    it 'broker job subcon collection status is :pending' do
      expect(broker_job.subcon_collection_status_name).to eq :pending
    end

    it 'subcon job prov collection status is :na' do
      expect(subcon_job.prov_collection_status_name).to eq :na
    end

    it 'prov work status should be :in_progress' do
      expect(job.work_status_name).to eq :in_progress
    end

    it 'broker work status should be :canceled' do
      expect(broker_job.work_status_name).to eq :canceled
    end

    it 'subcon job work status should be :in_progress' do
      expect(subcon_job.work_status_name).to eq :in_progress
    end

    it 'subcon_job status should be :canceled' do
      expect(subcon_job.status_name).to eq :canceled
    end


  end

  context 'when broker cancels the job' do
    before do
      cancel_the_job broker_job
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

    it 'broker job status should be :canceled' do
      expect(broker_job.status_name).to eq :canceled
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

    it 'broker job prov status should be :na' do
      expect(broker_job.provider_status_name).to eq :na
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

    it 'prov work status should be :canceled' do
      expect(job.work_status_name).to eq :canceled
    end

    it 'broker work status should be :canceled' do
      expect(broker_job.work_status_name).to eq :in_progress
    end

    it 'subcon job work status should be :in_progress' do
      expect(subcon_job.work_status_name).to eq :in_progress
    end

    it 'subcon_job status should be :canceled' do
      expect(subcon_job.status_name).to eq :canceled
    end

  end

  context 'when prov cancels the job' do
    before do
      cancel_the_job job
      job.reload
      broker_job.reload
      subcon_job.reload
    end

    it 'prov job billing status should be :pending' do
      expect(job.billing_status_name).to eq :pending
    end

    it 'prov job status should be :canceled' do
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

  context 'when subcon adds bom, collects and then cancels' do

    before do
      add_bom_to_job subcon_job, cost: 100, price: 1000, buyer: subcon
      collect_a_payment subcon_job, amount: 200, type: 'cash', collector: subcon
      cancel_the_job subcon_job
      job.reload
      subcon_job.reload
      broker_job.reload
    end

    it 'org balance for broker should be 202 (collection + fee reimb) ' do
      expect(job.organization.account_for(broker).balance).to eq Money.new(20200)
    end

    it 'broker balance for provider should be zero (collection + fee reimb)' do
      expect(broker_job.organization.account_for(org).balance).to eq Money.new(-20200)
    end

    it 'broker balance for subcon should be 200' do
      expect(broker_job.organization.account_for(subcon).balance).to eq Money.new(20000)
    end

    it 'subcon balance for broker should be -200' do
      expect(subcon_job.organization.account_for(org).balance).to eq Money.new(-20000)
    end

  end


end