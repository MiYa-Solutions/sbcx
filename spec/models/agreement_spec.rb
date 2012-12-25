# == Schema Information
#
# Table name: agreements
#
#  id                :integer         not null, primary key
#  name              :string(255)
#  counterparty_id   :integer
#  organization_id   :integer
#  description       :text
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#  status            :integer
#  counterparty_type :string(255)
#  type              :string(255)
#

require 'spec_helper'

describe Agreement do

  let(:new_agreement) { Agreement.new }

  subject { new_agreement }

  it "should have the expected attributes and methods" do
    should respond_to(:organization)
    should respond_to(:counterparty)
    should respond_to(:description)
    should respond_to(:name)
    should respond_to(:status)
    should respond_to(:events)
  end

  describe "associations" do
    it { should belong_to(:organization) }
    it { should belong_to(:counterparty) }
    it { should have_many(:events) }
  end


  describe "validation" do
    [:organization, :counterparty].each do |attr|
      it "must have a #{attr}" do
        new_agreement.errors[attr].should_not be_nil
      end
    end
  end

  describe "agreement when the counterparty is a member" do
    let(:agreement) { FactoryGirl.build(:agreement) }
    it "should trigger an event and notification to the counterparty" do
      expect {
        agreement.save
      }.to change(AgrSubmittedEvent.count).by(1)

    end
  end

  describe "agreement for local counterparty"

end
