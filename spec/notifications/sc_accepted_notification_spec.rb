require 'spec_helper'

describe ScAcceptedNotification do
  let(:service_call) { FactoryGirl.create(:my_service_call, subcontractor: FactoryGirl.create(:member).becomes(Subcontractor)) }


  it "is created once the service call is accepted by the subcontractor" do

    expect {
      FactoryGirl.create(:dispatcher, organization: service_call.provider)
      service_call.transfer
      subcon_sc = ServiceCall.find_by_organization_id_and_ref_id(service_call.subcontractor.id, service_call.ref_id)

      subcon_sc.accept
    }.to change { ScAcceptedNotification.count }.by (1)

  end

  describe " default content and subject" do
    let(:notification) {
      FactoryGirl.create(:dispatcher, organization: service_call.organization)
      service_call.transfer
      subcon_sc = ServiceCall.find_by_organization_id_and_ref_id(service_call.subcontractor.id, service_call.ref_id)
      subcon_sc.accept
      subcon_sc.technician = FactoryGirl.create(:technician, organization: subcon_sc.organization)

      subcon_sc.start
      subcon_sc.work_completed

      service_call.notifications.where(type: ScAcceptedNotification).last

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