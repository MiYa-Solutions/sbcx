# == Schema Information
#
# Table name: tickets
#
#  id                       :integer          not null, primary key
#  customer_id              :integer
#  notes                    :text
#  started_on               :datetime
#  organization_id          :integer
#  completed_on             :datetime
#  created_at               :datetime         not null
#  updated_at               :datetime         not null
#  status                   :integer
#  subcontractor_id         :integer
#  technician_id            :integer
#  provider_id              :integer
#  subcontractor_status     :integer
#  type                     :string(255)
#  ref_id                   :integer
#  creator_id               :integer
#  updater_id               :integer
#  settled_on               :datetime
#  billing_status           :integer
#  settlement_date          :datetime
#  name                     :string(255)
#  scheduled_for            :datetime
#  transferable             :boolean          default(TRUE)
#  allow_collection         :boolean          default(TRUE)
#  collector_id             :integer
#  collector_type           :string(255)
#  provider_status          :integer
#  work_status              :integer
#  re_transfer              :boolean          default(TRUE)
#  payment_type             :string(255)
#  subcon_payment           :string(255)
#  provider_payment         :string(255)
#  company                  :string(255)
#  address1                 :string(255)
#  address2                 :string(255)
#  city                     :string(255)
#  state                    :string(255)
#  zip                      :string(255)
#  country                  :string(255)
#  phone                    :string(255)
#  mobile_phone             :string(255)
#  work_phone               :string(255)
#  email                    :string(255)
#  subcon_agreement_id      :integer
#  provider_agreement_id    :integer
#  tax                      :float            default(0.0)
#  subcon_fee_cents         :integer          default(0), not null
#  subcon_fee_currency      :string(255)      default("USD"), not null
#  properties               :hstore
#  external_ref             :string(255)
#  subcon_collection_status :integer
#  prov_collection_status   :integer
#

require 'spec_helper'

describe SubconServiceCall do
  let(:service_call) { FactoryGirl.build(:local_subcon_job) }

  it 'should exist' do
    expect(service_call).to_not be_nil
  end

  it 'should have provider collection status' do
    expect(service_call).to respond_to(:prov_collection_status)
  end

  it 'prov collection status should be pending' do
    expect(service_call.prov_collection_status_name).to eq :pending
  end

  it 'should have a transfer method' do
    expect(service_call).to respond_to(:transfer)
  end

end
