# == Schema Information
#
# Table name: tickets
#
#  id                    :integer          not null, primary key
#  customer_id           :integer
#  notes                 :text
#  started_on            :datetime
#  organization_id       :integer
#  completed_on          :datetime
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#  status                :integer
#  subcontractor_id      :integer
#  technician_id         :integer
#  provider_id           :integer
#  subcontractor_status  :integer
#  type                  :string(255)
#  ref_id                :integer
#  creator_id            :integer
#  updater_id            :integer
#  settled_on            :datetime
#  billing_status        :integer
#  settlement_date       :datetime
#  name                  :string(255)
#  scheduled_for         :datetime
#  transferable          :boolean          default(FALSE)
#  allow_collection      :boolean          default(TRUE)
#  collector_id          :integer
#  collector_type        :string(255)
#  provider_status       :integer
#  work_status           :integer
#  re_transfer           :boolean
#  payment_type          :string(255)
#  subcon_payment        :string(255)
#  provider_payment      :string(255)
#  company               :string(255)
#  address1              :string(255)
#  address2              :string(255)
#  city                  :string(255)
#  state                 :string(255)
#  zip                   :string(255)
#  country               :string(255)
#  phone                 :string(255)
#  mobile_phone          :string(255)
#  work_phone            :string(255)
#  email                 :string(255)
#  subcon_agreement_id   :integer
#  provider_agreement_id :integer
#  tax                   :float            default(0.0)
#

require 'spec_helper'

describe TransferredServiceCall do
  let(:service_call) { FactoryGirl.create(:transferred_sc_with_new_customer) }

  subject { service_call }

  it "the customer should be associated with the provider and not the creator fo the service call" do

    service_call.customer.organization_id.should == service_call.provider_id

  end

  it { should validate_presence_of(:provider_agreement) }
end

