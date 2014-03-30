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

describe MyServiceCall do

  subject { MyServiceCall.new }

  it 'should have a subcon collection state machine with na as the status' do
    expect(subject.subcon_collection_status_name).to eq :na
  end

  it 'should have a customer collection state machine with pending as the status' do
    expect(subject.billing_status_name).to eq :pending
  end

  include_context 'basic job testing'

  describe '#fully_paid?' do
    it 'should respond to a fully_paid? method' do
      expect(job).to respond_to(:fully_paid?)
    end

    it 'should return false for none paid job' do
      expect(job.fully_paid?).to be_false
    end

    context 'when paid the full amount' do
      before do
        job.start_work
        add_bom_to_job job, price: 100, quantity: 1, cost: 10
        collect_a_payment job, type: 'cash', amount: '100', collector: job.organization, event: 'paid'
      end

      it 'should return false as the job is not doe yet' do
        expect(job.reload.fully_paid?).to be_false
      end

      it 'should return true after the job work is completed' do
        job.complete_work!
        expect(job.reload.fully_paid?).to be_true
      end
    end

    context 'when paid partial amount' do
      before do
        job.start_work
        add_bom_to_job job

        job.update_attributes(work_status_event: 'paid', payment_type: 'cash', payment_amount: '100')
      end

      it 'should return false' do
        expect(job.fully_paid?).to be_false
      end


    end
  end

  describe '#transfer' do
    include_context 'transferred job'

    it 'should create a SubconServiceCall' do
      expect { transfer_the_job }.to change { SubconServiceCall.count }.by(1)
    end

  end
end
