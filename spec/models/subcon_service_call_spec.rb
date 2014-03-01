require 'spec_helper'

describe SubconServiceCall do
  let(:service_call) { FactoryGirl.build(:local_subcon_job) }

  it 'should exist' do
    expect(service_call).to_not be_nil
  end

  it 'should have provider collection status' do
    expect(service_call).to respond_to(:prov_collection_status)
  end

  it 'should have a transfer method' do
    expect(service_call).to respond_to(:transfer)
  end

  describe '#transfer' do

    before do
      #service_call.provider.save!
      #service_call.organization.save!
      #service_call.provider_agreement.save!
      service_call.save!
      service_call.subcontractor    = service_call.organization.subcontractors.last
      service_call.subcon_agreement = service_call.organization.agreements.last
      service_call.transfer
    end

    it 'should change self to BrokerServiceCall' do
      expect { BrokerServiceCall.find(service_call.id) }.to_not raise_error
      expect { SubconServiceCall.find(service_call.id) }.to raise_error
    end

  end
end