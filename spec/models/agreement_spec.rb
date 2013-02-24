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
#  starts_at         :datetime
#  ends_at           :datetime
#  payment_terms     :integer
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
    should respond_to(:payments)
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
    [:organization, :counterparty, :creator, :starts_at].each do |attr|
      it { should validate_presence_of(attr)}
    end


  end

  it "an agreement can't be active if there are no posting rules" do

  end

  let(:agreement) { FactoryGirl.build(:agreement) }

  it "should have an initial status of draft" do
    agreement.status_name.should be (:draft)
  end

  it "only one active agreement should be allowed in a specific period" do
    new_agr = FactoryGirl.build(:new_agreement, organization: agreement.organization, counterparty: agreement.counterparty)
    new_agr.should_not be_valid
    new_agr.errors[:starts_at].should_not be_nil
  end

end
