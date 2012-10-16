require 'spec_helper'

describe TransferredServiceCall do
  let(:service_call) { FactoryGirl.create(:transferred_sc_with_new_customer) }

  subject { service_call }

  it "the customer should be associated with the provider and not the creator fo the service call" do

    service_call.customer.organization_id.should == service_call.provider_id

  end
end

