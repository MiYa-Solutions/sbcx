require "spec_helper"

describe NotificationMailer do
  describe "received service call notification " do
    it "should have the notification defined" do
      NotificationMailer.should respond_to(:received_service_call)
    end
  end
end
