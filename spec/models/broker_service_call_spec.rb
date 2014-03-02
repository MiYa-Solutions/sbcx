require 'spec_helper'

describe BrokerServiceCall do
  let(:service_call) do
    subcon_job = FactoryGirl.build(:local_subcon_job)
    subcon_job.save!
    subcon = FactoryGirl.build(:local_subcon)

    subcon_job.organization.subcontractors << subcon


    subcon_job.subcontractor    = subcon
    subcon_job.subcon_agreement = subcon_job.organization.agreements.last
    subcon_job.accept!
    subcon_job.transfer!
    BrokerServiceCall.find subcon_job.id
  end

  it 'should exist' do
    expect(service_call).to_not be_nil
  end

  it 'prov collection status should be pending' do
    expect(service_call.prov_collection_status_name).to eq :pending
  end

  it 'should have provider collection state machine' do
    job = BrokerServiceCall.new

    expect(job).to respond_to(:prov_collection_status)
    expect(job).to respond_to(:confirmed_prov_collection)
    expect(job).to respond_to(:deposited_prov_collection)
    expect(job).to respond_to(:deposit_disputed_prov_collection)
    expect(job).to respond_to(:collected_prov_collection)
  end

  it 'should have a subcon_collection_status state machine' do
    job = BrokerServiceCall.new

    expect(job).to respond_to(:subcon_collection_status)
    expect(job).to respond_to(:confirmed_subcon_collection)
    expect(job).to respond_to(:deposited_subcon_collection)
    expect(job).to respond_to(:deposit_disputed_subcon_collection)
    expect(job).to respond_to(:collected_subcon_collection)
  end

  it 'should NOT be allowed to transfer ' do
    expect(service_call.can_transfer?).to be_false
  end

end