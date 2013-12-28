# == Schema Information
#
# Table name: notifications
#
#  id              :integer          not null, primary key
#  subject         :string(255)
#  content         :text
#  status          :integer
#  user_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  notifiable_id   :integer
#  notifiable_type :string(255)
#  type            :string(255)
#

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

  describe 'associations' do
    it { expect(notification).to belong_to(:event) }
  end


end
