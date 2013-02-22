require 'spec_helper'

describe "ScSettleNotification" do
  let(:service_call) { FactoryGirl.create(:my_service_call, subcontractor: FactoryGirl.create(:member).becomes(Subcontractor)) }


  describe "transferred service call" do
    it "is created once the service call is marked as settled" do

      expect {
        service_call.transfer
        subcon_sc            = ServiceCall.find_by_organization_id_and_ref_id(service_call.subcontractor.id, service_call.ref_id)
        subcon_sc.technician = FactoryGirl.create(:technician, organization: subcon_sc.organization)
        subcon_sc.dispatch
        subcon_sc.work_completed
        subcon_sc.paid
        subcon_sc.settle

      }.to change { ScSettleNotification.count }.by (1) # should notify both provider and subcontractor

    end
  end
  describe "my service call" do
    it "is created once the service call is settled" do

      expect {
        service_call.transfer
        service_call.settle

      }.to change { ScSettleNotification.count }.by (1)

    end
  end

  describe " default content and subject" do
    let(:notification) {
      service_call.technician = FactoryGirl.create(:technician, organization: service_call.organization)
      service_call.dispatch
      service_call.work_completed
      service_call.paid
      service_call.settle
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