require 'spec_helper'

describe InviteDeclinedEvent do
  let(:org) { mock_model(Organization, id: 1, name: 'Test Org') }
  let(:affiliate) { mock_model(Affiliate, id: 2, name: 'Test Affiliate') }
  let(:org_user) { mock_model(User, organization: org) }
  let(:aff_user) { mock_model(User, organization: affiliate) }
  let(:invite) { mock_model(Invite, organization: org, organization_id: org.id, affiliate_id: affiliate.id, affiliate: affiliate, message: 'stam', notifications: []) }
  #let(:invite) { FactoryGirl.create(:invite, organization: org, affiliate: affiliate) }
  let(:event) { InviteDeclinedEvent.new(eventable: invite) }

  before do
    User.stub(:my_admins) do |arg|
      if arg == 1
        [org_user]
      elsif arg == 2
        [aff_user]
      else
        []
      end
    end
  end

  it 'should send a InviteAcceptedNotification notification to the affiliate when created' do
    notification = mock_model(InviteDeclinedNotification, save: true, :[]= => true, deliver: true, :[] => true, notifiable: invite)
    InviteDeclinedNotification.stub(:new => notification)

    InviteDeclinedNotification.should_receive(:new).with(user: org_user, event: event).and_return(notification)
    notification.should_receive(:deliver)

    event.save
  end


  context 'after validation' do

    before do
      event.valid?
    end

    it 'the event should be valid' do
      expect(event).to be_valid
    end

    it 'should have a reference id of 3' do
      expect(event.reference_id).to be 3
    end

    it 'should have a description taken from I18n' do
      expect(event.description).to eq I18n.t('invite_declined_event.description', org: org.name, affiliate: affiliate.name)
    end

    it 'should have a description taken from I18n' do
      expect(event.name).to eq I18n.t('invite_declined_event.name')
    end
  end

end