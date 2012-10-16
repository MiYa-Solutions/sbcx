# == Schema Information
#
# Table name: customers
#
#  id              :integer         not null, primary key
#  name            :string(255)
#  organization_id :integer
#  company         :string(255)
#  address1        :string(255)
#  address2        :string(255)
#  city            :string(255)
#  state           :string(255)
#  zip             :string(255)
#  country         :string(255)
#  phone           :string(255)
#  mobile_phone    :string(255)
#  work_phone      :string(255)
#  email           :string(255)
#  created_at      :datetime        not null
#  updated_at      :datetime        not null
#

require 'spec_helper'

describe Customer do
  let!(:customer) { FactoryGirl.build(:customer) }

  subject { customer }

  it { should respond_to(:email) }
  it { should respond_to(:updated_at) }
  it { should respond_to(:created_at) }
  it { should respond_to(:phone) }
  it { should respond_to(:company) }
  it { should respond_to(:address1) }
  it { should respond_to(:address2) }
  it { should respond_to(:country) }
  it { should respond_to(:state) }
  it { should respond_to(:city) }
  it { should respond_to(:zip) }
  it { should respond_to(:mobile_phone) }
  it { should respond_to(:work_phone) }

  it { should be_valid }

  it "saved successfully" do
    expect {
      customer.save
    }.to change { Customer.count }.by(1)
  end

  describe "accessible attributes" do
    it "should not allow access to organization_id" do
      expect do
        Customer.new(organization_id: "1")
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end

  describe "validation" do
    describe "when name is not present" do
      before do
        customer.name = ""
      end

      it { should_not be_valid }
    end
  end

  describe "authorization" do
    describe "customer not accessible users of other members" do
      pending "implement"
    end
  end


end
