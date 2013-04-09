# == Schema Information
#
# Table name: tickets
#
#  id                   :integer          not null, primary key
#  customer_id          :integer
#  notes                :text
#  started_on           :datetime
#  organization_id      :integer
#  completed_on         :datetime
#  created_at           :datetime         not null
#  updated_at           :datetime         not null
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
#  settlement_date      :datetime
#  name                 :string(255)
#  scheduled_for        :datetime
#  transferable         :boolean          default(FALSE)
#  allow_collection     :boolean          default(TRUE)
#  collector_id         :integer
#  collector_type       :string(255)
#  provider_status      :integer
#  work_status          :integer
#  re_transfer          :boolean
#  payment_type         :string(255)
#  subcon_payment       :string(255)
#  provider_payment     :string(255)
#

require 'spec_helper'

describe Ticket do
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
   :provider,
   :subcontractor,
   :technician_cost,
   :transferable?,
   :allow_collection?,
   :collector, :payment_type, :subcon_payment, :provider_payment].each do |attr|
    it { should respond_to attr }
  end

  it { should be_valid }

  describe "validation" do
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

  describe "associations" do
    it { should belong_to :organization }
    it { should have_many :boms }
    it { should belong_to :customer }
    it { should belong_to :technician }
    it { should belong_to :provider }
    it { should belong_to :subcontractor }
    it { should belong_to :collector }
  end

end
