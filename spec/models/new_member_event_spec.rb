require 'spec_helper'

describe NewMemberEvent do
  let(:user) { FactoryGirl.build(:org_admin) }
  let(:org) { user.organization }
  let(:event) {
    org.events << NewMemberEvent.new(name: "#{org.name} has signed up as a new member")
    org.events.last
  }

  subject { event }

  describe "event processing" do
    it "should process successfully" do
      expect {
        event.process_event
      }.should_not raise_error
    end

  end
end
