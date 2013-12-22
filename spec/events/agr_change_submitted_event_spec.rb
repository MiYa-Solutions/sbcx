require 'spec_helper'

describe AgrChangeSubmittedEvent do

  let(:org) { mock_model(Organization, id: 1, name: 'Test Org1', providers: [], subcontractors: []) }
  let(:creator) { mock_model(User, id: 1, name: 'Test Org1 User', organization: org) }
  let(:recipient) { mock_model(User, id: 2, name: 'Test Org3 User', organization: org2) }
  let(:org2) { mock_model(Organization, id: 2, name: 'Test Org2', providers: [], subcontractors: []) }
  let(:agreement) { mock_model(Agreement, id: 1, name: 'Test Acc', organization: org, counterparty: org2, events: [], notifications: []) }
  let(:event) { AgrChangeSubmittedEvent.new(eventable: agreement, creator: creator) }
  let(:notification) { mock_model(AgrChangeSubmittedNotification, deliver: true) }


  context 'when created' do

    before do
      AgrChangeSubmittedNotification.stub(:new => notification)
      User.stub(my_admins: [recipient])
    end

    it 'should send a notification' do
      AgrChangeSubmittedNotification.should_receive(:new)
      event.process_event
    end

  end


  context 'validation' do

    before do
      event.valid?
    end

    it 'the event should be valid' do
      expect(event).to be_valid
    end

    it 'should have a reference id of 200004' do
      expect(event.reference_id).to be 200004
    end

    it 'should have a description taken from I18n' do
      expect(event.description).to eq I18n.t('agr_change_submitted_event.description', agr_id: agreement.id, aff: org.name)
    end

    it 'should have a description taken from I18n' do
      expect(event.name).to eq I18n.t('agr_change_submitted_event.name')
    end
  end
end