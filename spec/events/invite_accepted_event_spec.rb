require 'spec_helper'

describe InviteAcceptedEvent do
  let(:org) { mock_model(Organization, id: 1, name: 'Test Org', providers: [], subcontractors: []) }
  let(:affiliate) { mock_model(Affiliate, id: 2, name: 'Test Affiliate', providers: [], subcontractors: []) }
  let(:org_user) { mock_model(User, organization: org) }
  let(:aff_user) { mock_model(User, organization: affiliate) }
  let(:invite) { mock_model(Invite, organization: org, organization_id: org.id, affiliate_id: affiliate.id, affiliate: affiliate, message: 'stam', notifications: []) }
  #let(:invite) { FactoryGirl.create(:invite, organization: org, affiliate: affiliate) }
  let(:event) { InviteAcceptedEvent.new(eventable: invite) }

  it 'should send a InviteAcceptedNotification notification to the affiliate when created' do
    notification = mock_model(InviteAcceptedNotification, save: true, :[]= => true, deliver: true, :[] => true, notifiable: invite)
    User.stub(:my_admins) do |arg|
      if arg == 1
        [org_user]
      else
        [aff_user]
      end
    end
    InviteAcceptedNotification.stub(:new => notification)

    InviteAcceptedNotification.should_receive(:new).with(user: org_user)
    #invite.notifications.should_receive(:<<).with(notification)
    #notification.should_receive(:save)
    notification.should_receive(:deliver)
    #event.should_receive(:notify)

    event.save
  end

  it 'should create flat fee agreements' do

    org.providers.should_receive(:<<).with(affiliate)
    org.subcontractors.should_receive(:<<).with(affiliate)
    affiliate.providers.should_receive(:<<).with(org)
    affiliate.subcontractors.should_receive(:<<).with(org)

    event.save
  end


  context 'after validation' do

    before do
      event.valid?
    end

    it 'the event should be valid' do
      expect(event).to be_valid
    end

    it 'should have a reference id of 2' do
      expect(event.reference_id).to be 4
    end

    it 'should have a description taken from I18n' do
      expect(event.description).to eq I18n.t('invite_accepted_event.description', org: org.name, affiliate: affiliate.name)
    end

    it 'should have a description taken from I18n' do
      expect(event.name).to eq I18n.t('invite_accepted_event.name')
    end
  end

end