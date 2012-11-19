require 'spec_helper'

describe Notification do
  let(:notification) { Notification.new(subject: "Test notification", content: Faker::Lorem.sentence) }
  subject { notification }

  it "should have the expected attributes" do
    should respond_to(:subject)
    should respond_to(:content)
    should respond_to(:created_at)
    should respond_to(:user_id)
    should respond_to(:status)
  end
end
