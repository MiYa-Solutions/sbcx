require 'spec_helper'

describe Invite do
  let(:invite) { Invite.new }
  let(:org) { FactoryGirl.build(:member) }
  let(:affiliate) { FactoryGirl.build(:member) }


  subject { invite }

  context 'associations' do
    it { should belong_to(:organization) }
    it { should belong_to(:affiliate) }
    it { should have_many(:events) }
    it { should have_many(:notifications) }

  end

  context 'public api' do
    it { should respond_to(:message) }

    it { should respond_to(:status) }

    it 'should have a state machine constants defined for the various states' do
      expect(invite.class).to have_constant(:STATUS_PENDING)
      expect(invite.class).to have_constant(:STATUS_ACCEPTED)
      expect(invite.class).to have_constant(:STATUS_DECLINED)
    end

    it 'should have a state machine defined' do
      expect(invite).to respond_to :status_name
    end

    it 'should have an accept and reject event' do
      expect(invite.status_events).to match_array [:accept, :decline]
    end

    it 'the default initial status should be pending' do
      expect(invite.status).to be Invite::STATUS_PENDING
    end

    it 'it should have an accepted state' do
      expect(invite).to respond_to :accepted?
    end

    it 'it should have an rejected state' do
      expect(invite).to respond_to :declined?
    end

    it 'creating an invite should trigger the NewInviteEvent creation' do

      event = mock_model(NewInviteEvent, save: true, :[]= => true, process_event: true, :eventable_id= => 1, :eventable_id => 1, eventable_type: 'Invite')

      NewInviteEvent.stub(:new => event)

      event.should_receive(:save)
      event.should_receive(:[]=).with('eventable_id', 1)
      event.should_receive(:[]=).with('eventable_type', 'Invite')

      invite = Invite.create(organization: org, affiliate: affiliate, message: "STAM")
    end

    it 'declining an invite should trigger a declined notification' do
      event = mock_model(InviteDeclinedEvent, save: true, :[]= => true, process_event: true, :eventable_id => 1, eventable_type: 'Invite')

      InviteDeclinedEvent.stub(:new => event)

      event.should_receive(:save)
      event.should_receive(:[]=).with('eventable_id', 1)
      event.should_receive(:[]=).with('eventable_type', 'Invite')

      invite = Invite.create(organization: org, affiliate: affiliate, message: "STAM")
      invite.decline
    end

    it 'accepting and invite should create a default flat fee agreement' do
      event = mock_model(InviteAcceptedEvent, save: true, :[]= => true, process_event: true, :eventable_id => 1, eventable_type: 'Invite')

      InviteAcceptedEvent.stub(:new => event)

      event.should_receive(:save)
      event.should_receive(:[]=).with('eventable_id', 1)
      event.should_receive(:[]=).with('eventable_type', 'Invite')

      invite = Invite.create(organization: org, affiliate: affiliate, message: "STAM")
      invite.accept
    end

  end

  context 'validations' do
    it { should validate_presence_of(:organization) }
    it { should validate_presence_of(:affiliate) }
    it { should validate_presence_of(:status) }
  end

  context 'authorization' do

    it 'only the creating organization is allowed to create an invite' do
      org.stub(id: 1)
      affiliate.stub(id: 2)
      role     = mock_model(Role, name: Role::ORG_ADMIN_ROLE_NAME)
      org_user = stub_model(User, organization: org, roles: [role])
      aff_user = stub_model(User, organization: affiliate, roles: [role])

      invite = Invite.new(organization: org, affiliate: affiliate)

      with_user org_user do
        should_be_allowed_to :create, invite
      end

      with_user aff_user do
        should_not_be_allowed_to :create, invite
      end

    end
    it 'only the affiliate is allowed to update the invite after creation' do
      org.stub(id: 1)
      affiliate.stub(id: 2)
      role     = mock_model(Role, name: Role::ORG_ADMIN_ROLE_NAME)
      org_user = stub_model(User, organization: org, roles: [role])
      aff_user = stub_model(User, organization: affiliate, roles: [role])

      invite = Invite.new(organization: org, affiliate: affiliate)

      with_user org_user do
        should_not_be_allowed_to :update, invite
        should_not_be_allowed_to :edit, invite
      end

      with_user aff_user do
        should_be_allowed_to :update, invite
        should_be_allowed_to :edit, invite
      end
    end
  end
end
