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

describe Ticket do
  let(:service_call) { FactoryGirl.build(:my_job) }

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
   :collector,
   :payment_type,
   :subcon_payment,
   :provider_payment,
   :tax,
   :provider_balance,
   :subcon_balance, :subcon_fee, :properties].each do |attr|
    it { should respond_to attr }
  end

  include_context 'Invoiceable'

  describe 'verify money attributes' do
    before do
      service_call.save!
    end
    [:subcon_balance, :provider_balance, :subcon_fee].each do |money_attr|
      it "#{money_attr} should be of type Money" do
        should monetize money_attr
      end
    end
  end


  it 'name should be set after create to a concatenation of tags and address' do

    service_call.tag_list = "Test Tag, Test Tag2"
    service_call.address1 = "Test Address"
    service_call.save
    service_call.reload.name.should == "Test Address: Test Tag, Test Tag2"

  end

  describe "validation" do
    it 'should be valid' do
      should be_valid
    end

    it 'organization must be present' do
      should validate_presence_of(:organization)
    end
    it 'tax must be numeric' do
      should validate_numericality_of(:tax)
    end


    it 'a customer or a new customer must be present' do
      service_call.customer      = nil
      service_call.new_customer  = nil
      service_call.customer_name = nil
      should_not be_valid
    end

    #it 'when the provider is not present' do
    #  service_call.provider = nil
    #  should_not be_valid
    #end

    it 'my job when transferred an agreement must be present' do
      sc = FactoryGirl.create(:my_service_call)
      expect do
        sc.transfer!
      end.to raise_error(StateMachine::InvalidTransition)
    end

    it 'subcon agreement must be one that matches the roles on the ticket' do
      service_call.organization.save!
      service_call.save!
      mem                           = FactoryGirl.create(:member_org)
      service_call.subcontractor    = mem.becomes(Subcontractor)
      agr                           = FactoryGirl.create(:subcon_agreement, organization: mem,
                                                         counterparty:                    service_call.organization,
                                                         creator:                         mem.users.first)
      agr.status                    = Agreement::STATUS_ACTIVE
      service_call.subcon_agreement = agr

      service_call.should_not be_valid
    end

    it 'should not require a project' do
      service_call.project = nil
      service_call.project_id = nil
      expect(service_call).to be_valid
    end

    it 'should validate that the project is owned by the same organization' do
      service_call.project = FactoryGirl.create(:project)
      expect {
        service_call.valid?
      }.to raise_error TicketExceptions::InvalidAssociation
    end

  end

  describe "associations" do
    it { should belong_to :organization }
    it { should belong_to :project }
    it { should have_many :boms }
    it { should have_many(:tags).through(:taggings) }
    it { should belong_to :customer }
    it { should belong_to :technician }
    it { should belong_to :provider }
    it { should belong_to :subcontractor }
    it { should belong_to :collector }
    it { should belong_to :subcon_agreement }
    it { should belong_to :provider_agreement }
  end

  context 'when created' do
    before do
      service_call.scheduled_for = Time.zone.now
      service_call.save! unless example.metadata[:skip_create]
    end

    it 'should create an appointment', skip_create: true do
      meeting = mock_model(Appointment, :[]= => true, :appointable_id= => true, save: true, :title= => true)
      Appointment.stub(new: meeting)
      Appointment.should_receive(:new).with(organization: service_call.organization,
                                            title:        anything(),
                                            description:  anything(),
                                            starts_at:    an_instance_of(ActiveSupport::TimeWithZone),
                                            ends_at:      an_instance_of(ActiveSupport::TimeWithZone))
      service_call.save!
    end
  end

  pending '#customer_balance'
  pending '#customer_entries'

end
