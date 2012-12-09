require 'spec_helper'

describe ScStartNotification do
  let(:service_call) { FactoryGirl.create(:my_service_call, subcontractor: FactoryGirl.create(:member).becomes(Subcontractor)) }


  describe "for transferred service call" do
    it "is created once the subcontractor starts the service call" do

      expect {
        service_call.transfer
        subcon_sc = ServiceCall.find_by_organization_id_and_ref_id(service_call.subcontractor.id, service_call.ref_id)
        FactoryGirl.create(:dispatcher, organization: subcon_sc.organization)
        subcon_sc.technician = FactoryGirl.create(:technician, organization: subcon_sc.organization)
        subcon_sc.dispatch
        subcon_sc.start

      }.to change { ScStartNotification.count }.by (1)

    end
  end
  describe "my service call" do
    it "is created once the service call is dispatched" do

      expect {
        service_call.technician = FactoryGirl.create(:technician, organization: service_call.organization)
        service_call.dispatch

      }.to change { ScDispatchNotification.count }.by (1)

    end
  end

  describe " default content and subject" do
    let(:notification) {
      service_call.technician = FactoryGirl.create(:technician, organization: service_call.organization)
      service_call.dispatch
      service_call.notifications.last
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