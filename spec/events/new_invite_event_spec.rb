require 'spec_helper'

describe NewInviteEvent do
  let(:org) { mock_model(Organization, id: 1000, name: 'Test Org') }
  let(:affiliate) { mock_model(Affiliate, id: 2000, name: 'Test Affiliate') }
  let(:org_user) { mock_model(User, organization: org) }
  let(:aff_user) { mock_model(User, organization: affiliate) }
  let(:invite) { mock_model(Invite, organization: org, organization_id: org.id, affiliate_id: affiliate.id, affiliate: affiliate, message: 'stam', notifications: []) }
  #let!(:invite) { Invite.new(organization: org, affiliate: affiliate, message: 'stam') }
  let(:event) { NewInviteEvent.new(eventable: invite) }

  before do
    User.stub(:my_admins) do |arg|
      if arg == 1000
        [org_user]
      elsif arg == 2000
        [aff_user]
      else
        []
      end
    end
  end

  it 'should send a NewInviteNotification notification to the affiliate when created' do
    notification = mock_model(NewInviteNotification, save: true, :[]= => true, deliver: true, :[] => true)
    NewInviteNotification.stub(:new).and_return(notification)

    NewInviteNotification.should_receive(:new).with(user: aff_user, event: anything()).and_return(notification)
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

    it 'should have a reference id of 2' do
      expect(event.reference_id).to be 2
    end

    it 'should have a description taken from I18n' do
      expect(event.description).to eq I18n.t('new_invite_event.description', org: org.name, affiliate: affiliate.name)
    end

    it 'should have a description taken from I18n' do
      expect(event.name).to eq I18n.t('new_invite_event.name')
    end
  end

end