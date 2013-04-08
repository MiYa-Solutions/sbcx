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

describe TransferredServiceCall do
  let(:service_call) { FactoryGirl.create(:transferred_sc_with_new_customer) }

  subject { service_call }

  it "the customer should be associated with the provider and not the creator fo the service call" do

    service_call.customer.organization_id.should == service_call.provider_id

  end
end

