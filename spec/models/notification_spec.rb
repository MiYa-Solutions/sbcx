require 'spec_helper'

describe Notification do
  let(:notification) { Notification.new }
  subject { notification }

  it "should have the expected attributes and methods" do
    should respond_to(:subject)
    should respond_to(:content)
    should respond_to(:created_at)
    should respond_to(:user)
    should respond_to(:status)
    should respond_to(:notifiable)
    should respond_to(:deliver)
  end

  describe "validation" do
    [:subject, :content, :user, :status].each do |attr|
      it "must have a #{attr}" do
        should raise_exception # as a notification should not be instantiated and must have a subclass
        notification.errors[attr].should_not be_nil
      end
    end
  end


end
