# == Schema Information
#
# Table name: service_calls
#
#  id               :integer         not null, primary key
#  customer_id      :integer
#  notes            :text
#  started_on       :datetime
#  organization_id  :integer
#  completed_on     :datetime
#  created_at       :datetime        not null
#  updated_at       :datetime        not null
#  status           :integer
#  subcontractor_id :integer
#

require 'spec_helper'

describe ServiceCall do
  let(:service_call) { FactoryGirl.build(:service_call) }

  subject { service_call }

  it { should respond_to(:customer_id) }
  it { should respond_to(:organization_id) }
  it { should respond_to(:technician_id) }

  it { should be_valid }

  describe "when organization is not present" do
    before { service_call.organization = nil }
    it { should_not be_valid }
  end

  describe "when customer is not present" do
    before { service_call.customer = nil }
    it { should_not be_valid }
  end
  describe "when provider is not present" do
    before { service_call.provider = nil }
    it { should_not be_valid }
  end


end
