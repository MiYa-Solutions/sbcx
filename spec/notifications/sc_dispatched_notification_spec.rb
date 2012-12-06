require 'spec_helper'

describe ScDispatchedNotification do
  let(:service_call) { FactoryGirl.create(:my_service_call, subcontractor: FactoryGirl.create(:member).becomes(Subcontractor)) }


  it "is created once the service call is dispatched by the subcontractor" do

    expect {
      service_call.transfer
      FactoryGirl.create(:dispatcher, organization: service_call.organization)
      subcon_sc            = ServiceCall.find_by_organization_id_and_ref_id(service_call.subcontractor.id, service_call.ref_id)
      subcon_sc.technician = FactoryGirl.create(:technician, organization: subcon_sc.organization)

      subcon_sc.dispatch

    }.to change { ScDispatchedNotification.count }.by (1)

  end

  describe " default content and subject" do
    let(:notification) {
      service_call.transfer
      FactoryGirl.create(:dispatcher, organization: service_call.organization)
      subcon_sc            = ServiceCall.find_by_organization_id_and_ref_id(service_call.subcontractor.id, service_call.ref_id)
      subcon_sc.technician = FactoryGirl.create(:technician, organization: subcon_sc.organization)

      subcon_sc.dispatch

      subcon_sc.notifications.last

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