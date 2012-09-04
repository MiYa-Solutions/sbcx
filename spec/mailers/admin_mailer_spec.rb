require "spec_helper"

describe AdminMailer do
  describe "sign_up_alert" do
    let(:mail) { AdminMailer.sign_up_alert }

    it "renders the headers" do
      mail.subject.should eq("Sign up alert")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
