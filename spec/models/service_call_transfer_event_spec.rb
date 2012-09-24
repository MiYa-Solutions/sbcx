# == Schema Information
#
# Table name: events
#
#  id             :integer         not null, primary key
#  name           :string(255)
#  type           :string(255)
#  description    :string(255)
#  eventable_type :string(255)
#  eventable_id   :integer
#  created_at     :datetime        not null
#  updated_at     :datetime        not null
#  user_id        :integer
#  reference_id   :integer
#

require 'spec_helper'

describe ServiceCallTransferEvent do

  let!(:event) { FactoryGirl.create(:service_call_transfer_event) }
  subject { event }

  describe "event processing" do
    it "should process successfully" do
      expect {
        event.process_event
      }.should_not raise_error
    end

    it "should create another record for the subcontractor" do
      expect {
        event.process_event
      }.to change { ServiceCall.count }.by (1)
    end

  end

  describe "event attributes" do
    specify { event.reference_id.should eq(2) }
  end

  describe " transferred new service call attributes" do
    let(:service_call) { event.eventable }
    let(:new_service_call) { event.process_event }

    it "organization id should be the the service call's subcontractor id" do
      new_service_call.organization_id.should == service_call.subcontractor_id
    end
    it "provider id should be the same as service call's organization id" do
      new_service_call.provider_id.should == service_call.organization_id
    end

  end

end
