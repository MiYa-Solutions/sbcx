require 'spec_helper'

describe ScReceivedNotification do
  let(:service_call) { job }

  include_context 'transferred job'


  it "is created once the service call is transferred to the subcontractor" do

    expect {
      transfer_the_job
    }.to change { ScReceivedNotification.count }.by (1)

  end

  describe " default content and subject" do
    let(:notification) {
      transfer_the_job
      ServiceCall.find_by_organization_id_and_ref_id(service_call.subcontractor.id, service_call.ref_id).notifications.first
    }

    subject { notification }

    [:default_subject, :default_content].each do |method|
      it "#{method} should not be blank or nil" do
        should respond_to(method)
        notification.send(method).should_not be_blank
      end
    end
  end


end