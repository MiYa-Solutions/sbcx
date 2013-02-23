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
#  creator_id        :integer
#  updater_id        :integer
#

require 'spec_helper'

describe Agreement do

  let!(:new_agreement) { Agreement.new }

  subject { new_agreement }

  it "should have the expected attributes and methods" do
    should respond_to(:organization)
    should respond_to(:counterparty)
    should respond_to(:description)
    should respond_to(:name)
    should respond_to(:status)
    should respond_to(:change_reason)
    should respond_to(:starts_at)
    should respond_to(:ends_at)
    should respond_to(:payment_methods)
    should respond_to(:payment_terms)
  end

  describe "associations" do
    it { should belong_to(:organization) }
    it { should belong_to(:counterparty) }
    it { should have_many(:events) }
    it { should have_many(:notifications) }
    it { should have_many(:posting_rules) }
  end


  describe "validation" do
    [:organization, :counterparty, :creator].each do |attr|
      it "must have a #{attr} populated" do
        new_agreement.should_not be_valid
        new_agreement.errors[attr].should_not be_empty
      end
    end
  end

  let(:agreement) { FactoryGirl.build(:agreement) }

  it "should have an initial status of draft" do
    agreement.status_name.should be (:draft)
  end

end
