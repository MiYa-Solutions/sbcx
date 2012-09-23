# == Schema Information
#
# Table name: organizations
#
#  id                :integer         not null, primary key
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
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#

require 'spec_helper'

describe Organization do

  let(:user) { FactoryGirl.build(:org_admin) }
  let(:org) { user.organization }

  subject { org }

  it { should respond_to(:email) }
  it { should respond_to(:name) }
  it { should respond_to(:phone) }
  it { should respond_to(:website) }
  it { should respond_to(:company) }
  it { should respond_to(:address1) }
  it { should respond_to(:address2) }
  it { should respond_to(:city) }
  it { should respond_to(:state) }
  it { should respond_to(:zip) }
  it { should respond_to(:country) }
  it { should respond_to(:mobile) }
  it { should respond_to(:work_phone) }
  it { should respond_to(:subcontrax_member) }
  it { should respond_to(:status) }
  it { should respond_to(:created_at) }
  it { should respond_to(:updated_at) }
  it { should respond_to(:users) }
  it { should respond_to(:customers) }
  it { should respond_to(:organization_roles) }
  it { should respond_to(:service_calls) }
  it { should respond_to(:subcontractors) }
  it { should respond_to(:providers) }

  it { should be_valid }

  it "saved successfully" do
    expect {
      org.save
    }.to change { Organization.count }.by(1)
  end

  describe "accessible attributes" do
    it "should not allow access to subcontrax_member" do
      expect do
        Organization.new(subcontrax_member: true)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
    it "should not allow access to status" do
      expect do
        Organization.new(status: 2)
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end


  end
  describe "when name is not present" do
    before { org.name = " " }
    it { should_not be_valid }
  end
  describe "when there are no organization roles assigned" do
    before { org.organization_roles = [] }
    it { should_not be_valid }
  end


end
