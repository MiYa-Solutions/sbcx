# == Schema Information
#
# Table name: events
#
#  id                  :integer          not null, primary key
#  name                :string(255)
#  type                :string(255)
#  description         :string(255)
#  eventable_type      :string(255)
#  eventable_id        :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  user_id             :integer
#  reference_id        :integer
#  creator_id          :integer
#  updater_id          :integer
#  triggering_event_id :integer
#

require 'spec_helper'

describe Event do

  let!(:event) { FactoryGirl.build(:event) }


  subject { event }

  it { should respond_to(:user_id) }
  it { should respond_to(:name) }
  it { should respond_to(:type) }
  it { should respond_to(:description) }
  it { should respond_to(:eventable_type) }
  it { should respond_to(:eventable_id) }
  it { should respond_to(:created_at) }
  it { should respond_to(:updated_at) }
  it { should respond_to(:reference_id) }

  describe "should not be instantiated" do
    it "an event must be instantiated using a subclass that implements process_event method" do
      expect do
        event.process_event
      end.should raise_error
    end

  end


  it { should raise_exception } # as event should not be instantiated by himself and must a have a subclass
end
