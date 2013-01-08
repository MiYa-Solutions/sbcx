require 'spec_helper'

describe AgrNewSubconEvent do

  let(:event) { AgrNewSubconEvent.new }

  subject { event }

  describe "description is concatenated with the user reason" do
    let(:agreement) { FactoryGirl.create(:subcontracting_agreement) }
    let(:org_user) { agreement.organization.org_admins.first }
    before do
      agreement.change_reason = "Test reason"
      agreement.updater       = org_user
      agreement.submit_for_approval
    end

    it "the event should be associated to the agreement with the proper user message" do
      agreement.events.count.should be { 2 }
      agreement.events.last.description.should include("Test reason")
    end
  end


end
