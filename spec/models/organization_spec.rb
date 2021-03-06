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
#  parent_org_id     :integer
#  industry          :string(255)
#  other_industry    :string(255)
#

require 'spec_helper'

describe Organization do

  let(:org) { FactoryGirl.build(:member_org) }

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

    it 'should have a member? method which is an alias of subcontrax_member?' do
      org.subcontrax_member = true
      expect(org.member?).to eq org.subcontrax_member?
      org.subcontrax_member = false
      expect(org.member?).to eq org.subcontrax_member?
    end

    it 'local org should be unique for member' do
      org.save!
      org2 = FactoryGirl.build(:member_org)

      local_org1 = FactoryGirl.build(:local_org)
      local_org2 = FactoryGirl.build(:local_org, name: local_org1.name)

      org.affiliates << local_org1
      expect(local_org1).to be_valid

      expect { org.affiliates << local_org2 }.to raise_error(ActiveRecord::RecordInvalid)
      expect { org2.affiliates << local_org2 }.to_not raise_error(ActiveRecord::RecordInvalid)

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
    it { should have_many(:affiliates).through(:accounts) }
    it { should have_many(:invites) }
    it { should have_many(:invite_req) }
    it { should have_many(:projects) }
  end

  it "saved successfully" do
    expect {
      org.save
    }.to change { Organization.count }.by(1)
  end

  describe 'adding a provider' do
    let(:prov) { FactoryGirl.create(:org_admin).organization }

    before do
      org.save!
      org.providers << prov
    end

    it 'should create a flat_fee agreement by default' do

      agreements = Agreement.our_agreements(org, prov)
      expect(agreements.size).to eq 1
      expect(agreements.first).to be_active
      expect(FlatFee.where(agreement_id: agreements.first.id).size).to eq 1

    end
  end

  describe 'industry' do

    it 'the class should have the list of industries' do
      expect(Organization.industries).to eq([:locksmith,
                                             :security_systems,
                                             :carpet_cleaning,
                                             :plumbing,
                                             :electricity,
                                             :construction,
                                             :transportation,
                                             :landscaping,
                                             :towing,
                                             :auto_repair,
                                             :glass_repair,
                                             :photography,
                                             :other])
    end
    it 'should respond to #intrustry and #industry=' do
      expect(org).to respond_to(:industry)
      expect(org).to respond_to(:industry=)
    end
    it 'should validate that the industry is one of the allowed industries' do
      org.industry = :invalid_industry
      expect(org).to_not be_valid
      org.industry = 'locksmith'
      expect(org).to be_valid
    end

    it 'should validate presence of industry' do
      expect(org).to validate_presence_of(:industry)
    end
    it 'should validate presence of other_industry when industry is set to other' do
      org.industry = 'locksmith'
      expect(org).to be_valid
      expect(org.errors).to_not have_key(:other_industry)
      org.industry = 'other'
      expect(org).to_not be_valid
      expect(org.errors).to have_key(:other_industry)
    end
    it '#industry_name' do
      org.industry = 'locksmith'
      expect(org.industry_name).to eq 'Locksmith'
      org.industry       = 'other'
      org.other_industry = 'other name'
      expect(org.industry_name).to eq 'other name'
    end
    it 'Organization class has #human_industry_name' do
      expect(Organization.human_industry_name('locksmith')).to eq 'Locksmith'
      expect(Organization.human_industry_name('no_name')).to eq ''
    end

  end


end
