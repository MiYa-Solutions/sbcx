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
#  transferable          :boolean          default(TRUE)
#  allow_collection      :boolean          default(TRUE)
#  collector_id          :integer
#  collector_type        :string(255)
#  provider_status       :integer
#  work_status           :integer
#  re_transfer           :boolean          default(TRUE)
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
#  subcon_fee_cents      :integer          default(0), not null
#  subcon_fee_currency   :string(255)      default("USD"), not null
#  properties            :hstore
#

require 'spec_helper'

describe ServiceCall do
  include_context 'transferred job'

  let(:service_call) { job }

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
      transfer_the_job
      subcon_job.provider     = nil
      subcon_job.new_customer = nil
    end

    it { expect(subcon_job).to_not be_valid }
  end

  it 'should not allow to change the tax if the work is done' do
    service_call.work_status = ServiceCall::WORK_STATUS_DONE
    service_call.name        = "lklklk"
    service_call.should be_valid
    service_call.tax = 5.0
    service_call.should_not be_valid
  end

  it 'should not allow to change the tax if transferred' do
    transfer_the_job
    subcon_job.status        = ServiceCall::STATUS_TRANSFERRED
    subcon_job.subcontractor = FactoryGirl.create(:local_subcon)
    subcon_job.name          = "lklklk"
    subcon_job.should be_valid
    subcon_job.tax = 5.0
    subcon_job.should_not be_valid
  end

  it 'should allow to change the tax when the work is in progress' do
    service_call.work_status = ServiceCall::WORK_STATUS_IN_PROGRESS
    service_call.tax         = 5.0
    service_call.should be_valid
  end

  describe 'job lifecycle' do
    setup_standard_orgs

    let(:job) { FactoryGirl.create(:my_service_call, organization: org) }

    it { job.should be_valid }

    it 'transfer job should create another job for the subcontractor' do
      job.subcontractor = org2.becomes(Subcontractor)

      expect do
        job.subcon_agreement = Agreement.find_by_organization_id_and_counterparty_id(org.id, org2.id)
        job.transfer
      end.to change(ServiceCall, :count).by(1)

    end

    describe 'transfer job and allow re-transfer' do
      before do
        job.re_transfer      = true
        job.subcontractor    = org2.becomes(Subcontractor)
        job.subcon_agreement = Agreement.find_by_organization_id_and_counterparty_id(org.id, org2.id)
        job.transfer
      end

      let(:subcon_job) { Ticket.find_by_organization_id_and_ref_id(org2.id, job.id) }

      it 'status should change to transferred' do
        job.status.should be(Ticket::STATUS_TRANSFERRED)
      end

      it 'subcon job status should be received new' do
        subcon_job.status.should be(TransferredServiceCall::STATUS_NEW)
      end

      describe 'passed on job' do
        before do
          subcon_job.accept
          subcon_job.subcontractor    = org3.becomes(Subcontractor)
          subcon_job.subcon_agreement = Agreement.find_by_organization_id_and_counterparty_id(org2.id, org3.id)
          subcon_job.transfer
        end

        let(:org3_job) { Ticket.find_by_organization_id_and_ref_id(org3.id, job.id) }

        it 'should create a job for the third sucon' do
          org3_job.should_not be_nil
          Ticket.count.should be(3)
        end


      end
    end

  end

  pending '#invoice - pdf creation and correctenss'

end
