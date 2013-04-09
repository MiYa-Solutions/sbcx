# == Schema Information
#
# Table name: organizations
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  phone             :string(255)
#  website           :string(255)
#  company           :string(255)
#  address1          :string(255)
#  address2          :string(255)
#  city              :string(255)
#  state             :string(255)
#  zip               :string(255)
#  country           :string(255)
#  mobile            :string(255)
#  work_phone        :string(255)
#  email             :string(255)
#  subcontrax_member :boolean
#  status            :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

require 'spec_helper'

describe Organization do

  let(:user) { FactoryGirl.build(:org_admin) }
  let(:org) { user.organization }

  subject { org }

  it "should have the expected attributes and methods" do
    should respond_to(:email)
    should respond_to(:name)
    should respond_to(:phone)
    should respond_to(:website)
    should respond_to(:company)
    should respond_to(:address1)
    should respond_to(:address2)
    should respond_to(:city)
    should respond_to(:state)
    should respond_to(:zip)
    should respond_to(:country)
    should respond_to(:mobile)
    should respond_to(:work_phone)
    should respond_to(:subcontrax_member)
    should respond_to(:status)
    should respond_to(:created_at)
    should respond_to(:updated_at)
    should respond_to(:users)
    should respond_to(:customers)
    should respond_to(:organization_roles)
    should respond_to(:service_calls)
    should respond_to(:subcontractors)
    should respond_to(:providers)
    should respond_to(:materials)
    should respond_to(:accounts)
    should respond_to(:my_user?)
  end

  it { should be_valid }

  describe "validation" do
    # presance validation
    [:name, :status].each do |attr|
      it "must have a #{attr} populated" do
        org.send("#{attr}=", "")
        org.errors[attr].should_not be_nil
      end
    end

    it "name should be unique across all members" do
      new_mem = org.dup
      new_mem.should_not be_valid
      new_mem.errors[:name].should_not be_nil
    end
    it "organization_roles must be present" do
      org.organization_roles = []
      org.should_not be_valid
      org.errors[:organization_roles].should_not be_nil
    end

  end

  describe "associations" do
    it { should have_many(:users) }
    it { should have_many(:service_calls) }
    it { should have_many(:customers) }
    it { should have_many(:materials) }
    it { should have_many(:accounts) }
    it { should have_many(:organization_roles) }
    it { should have_many(:subcontractors).through(:agreements).conditions("agreements.type = 'SubcontractingAgreement' AND agreements.status = #{OrganizationAgreement::STATUS_ACTIVE}") }
    it { should have_many(:providers).through(:reverse_agreements).conditions("agreements.type = 'SubcontractingAgreement' AND agreements.status = #{OrganizationAgreement::STATUS_ACTIVE}") }
  end

  it "saved successfully" do
    expect {
      org.save
    }.to change { Organization.count }.by(1)
  end


end
