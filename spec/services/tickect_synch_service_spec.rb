require 'spec_helper'

describe TicketSynchService do

  setup_standard_orgs

  let(:synched_job) { FactoryGirl.create(:my_service_call, organization: org) }
  let(:updated_job) do
    synched_job.subcontractor    = org2.becomes(Subcontractor)
    synched_job.subcon_agreement = Agreement.find_by_organization_id_and_counterparty_id(org.id, org2.id)
    synched_job.transfer
    Ticket.find_by_organization_id_and_ref_id(org2.id, synched_job.ref_id)
  end


  it 'should update the location attributes' do
    attr = { address1:     "New Addr2",
             address2:     "New Addr2",
             city:         "New City",
             state:        "New State",
             zip:          "777777",
             country:      "New Country",
             phone:        "New Phone",
             mobile_phone: "New Mobile",
             work_phone:   "New Work Phone" }

    updated_job.update_attributes(attr)

    synched_job.address1.should == attr[:address1]

  end
end