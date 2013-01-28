# == Schema Information
#
# Table name: tickets
#
#  id                   :integer         not null, primary key
#  customer_id          :integer
#  notes                :text
#  started_on           :datetime
#  organization_id      :integer
#  completed_on         :datetime
#  created_at           :datetime        not null
#  updated_at           :datetime        not null
#  status               :integer
#  subcontractor_id     :integer
#  technician_id        :integer
#  provider_id          :integer
#  subcontractor_status :integer
#  type                 :string(255)
#  ref_id               :integer
#  creator_id           :integer
#  updater_id           :integer
#  settled_on           :datetime
#  billing_status       :integer
#  total_price          :decimal(, )
#  settlement_date      :datetime
#  name                 :string(255)
#  scheduled_for        :datetime
#

require 'spec_helper'

describe ServiceCall do
  let(:service_call) { FactoryGirl.build(:transferred_sc_with_new_customer) }

  subject { service_call }

  [:customer_id,
   :organization_id,
   :technician_id,
   :creator_id,
   :updater_id,
   :name,
   :settlement_date,
   :address1,
   :address2,
   :country,
   :city,
   :state,
   :zip,
   :phone,
   :mobile_phone,
   :boms,
   :scheduled_for,
   :total_price,
   :total_cost,
   :total_profit,
   :provider_cost,
   :subcontractor_cost,
   :technician_cost].each do |attr|
    it { should respond_to attr }
  end
  #it "should have the expected attributes" do
  #  should respond_to(:customer_id)
  #  should respond_to(:organization_id)
  #  should respond_to(:technician_id)
  #  should respond_to(:creator_id)
  #  should respond_to(:updater_id)
  #  should respond_to(:name)
  #  should respond_to(:settlement_date)
  #  should respond_to(:address1)
  #  should respond_to(:address2)
  #  should respond_to(:country)
  #  should respond_to(:city)
  #  should respond_to(:state)
  #  should respond_to(:zip)
  #  should respond_to(:phone)
  #  should respond_to(:mobile_phone)
  #  should respond_to(:boms)
  #  should respond_to(:scheduled_for)
  #  should respond_to(:total_price)
  #  should respond_to(:total_cost)
  #  should respond_to(:total_profit)
  #  should respond_to(:provider_cost)
  #  should respond_to(:subcontractor_cost)
  #  should respond_to(:technician_cost)
  #end


  it { should be_valid }

  describe "when organization is not present" do
    before { service_call.organization = nil }
    it { should_not be_valid }
  end

  describe "when customer and new_customer is not present" do
    before do
      service_call.customer     = nil
      service_call.new_customer = nil
    end
    it { should_not be_valid }
  end
  describe "when provider is not present" do
    before do
      service_call.provider     = nil
      service_call.new_customer = nil
    end

    it { should_not be_valid }
  end


end
