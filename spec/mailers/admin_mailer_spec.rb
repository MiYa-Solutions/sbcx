require "spec_helper"

describe AdminMailer do
  let(:user) { FactoryGirl.build(:org_admin) }
  let(:org) { user.organization }

  describe "sign_up_alert" do
    let(:mail) { AdminMailer.sign_up_alert(org) }

    it "renders the headers" do
      mail.subject.should match("new member!!!")
      mail.to.should eq([ENV["NEW_MEMBER_EVENT_EMAILS"]])
      mail.from.should eq(["admin@subcontrax.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("YALLA")
    end
  end

end
