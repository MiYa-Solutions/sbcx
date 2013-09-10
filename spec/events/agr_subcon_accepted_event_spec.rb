require 'spec_helper'

describe AgrSubconAcceptedEvent do

  let(:agr) { FactoryGirl.create(:subcontracting_agreement) }

  before do
    User.stamper = agr.organization.users.first
    agr.submit_for_approval
    User.stamper = agr.counterparty.users.first
    agr.accept
  end

  it 'should be triggered when the accept event is activated on the agreement' do
    agr.events.last.should be_instance_of(AgrSubconAcceptedEvent)
  end

  it 'should trigger a notification' do
    agr.notifications.last.should be_an_instance_of(AgrSubconAcceptedNotification)
  end
  it 'should have an id of 200003' do
    agr.events.last.reference_id.should be(200003)
  end


end