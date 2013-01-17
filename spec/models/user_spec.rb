# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(255)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  organization_id        :integer
#  first_name             :string(255)
#  last_name              :string(255)
#  phone                  :string(255)
#  company                :string(255)
#  address1               :string(255)
#  address2               :string(255)
#  country                :string(255)
#  state                  :string(255)
#  city                   :string(255)
#  zip                    :string(255)
#  mobile_phone           :string(255)
#  work_phone             :string(255)
#  preferences            :hstore
#

# == Schema Information
#
# Table name: users
#
#  id                     :integer         not null, primary key
#  email                  :string(255)     default(""), not null
#  encrypted_password     :string(255)     default(""), not null
#  reset_password_token   :string(255)
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer         default(0)
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string(255)
#  last_sign_in_ip        :string(255)
#  created_at             :datetime        not null
#  updated_at             :datetime        not null
#  organization_id        :integer
#  first_name             :string(255)
#  last_name              :string(255)
#  phone                  :string(255)
#  company                :string(255)
#  address1               :string(255)
#  address2               :string(255)
#  country                :string(255)
#  state                  :string(255)
#  city                   :string(255)
#  zip                    :string(255)
#  mobile_phone           :string(255)
#  work_phone             :string(255)
#

require 'spec_helper'

describe User do
  let(:user) { FactoryGirl.build(:org_admin) }
  let(:owner_admin) { FactoryGirl.build(:owner_admin, organization: user.organization) }

  subject { user }

  it { should respond_to(:email) }
  it { should respond_to(:organization) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_created_at) }
  it { should respond_to(:roles) }
  it { should respond_to(:last_sign_in_ip) }
  it { should respond_to(:current_sign_in_ip) }
  it { should respond_to(:encrypted_password) }
  it { should respond_to(:reset_password_sent_at) }
  it { should respond_to(:remember_created_at) }
  it { should respond_to(:sign_in_count) }
  it { should respond_to(:current_sign_in_at) }
  it { should respond_to(:last_sign_in_at) }
  it { should respond_to(:updated_at) }
  it { should respond_to(:created_at) }
  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
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
      user.save
    }.to change { User.count }.by(1)
  end

  # removed as the test in no longer works now that we use strong parameters
  #describe "accessible attributes" do
  #  it "should not allow access to last_sign_ip" do
  #    expect do
  #      User.new(last_sign_in_ip: "1")
  #    end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
  #  end
  #  it "should not allow access to current_sign_in_ip" do
  #    expect do
  #      User.new(current_sign_in_ip: "1")
  #    end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
  #  end
  #  it "should not allow access to encrypted_password" do
  #    expect do
  #      User.new(encrypted_password: "1")
  #    end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
  #  end
  #  it "should not allow access to reset_password_sent_at" do
  #    expect do
  #      User.new(reset_password_sent_at: "1")
  #    end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
  #  end
  #  it "should not allow access to remember_created_at" do
  #    expect do
  #      User.new(remember_created_at: "1")
  #    end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
  #  end
  #  it "should not allow access to sign_in_count" do
  #    expect do
  #      User.new(sign_in_count: "1")
  #    end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
  #  end
  #  it "should not allow access to current_sign_in_at" do
  #    expect do
  #      User.new(current_sign_in_at: "1")
  #    end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
  #  end
  #  it "should not allow access to last_sign_in_at" do
  #    expect do
  #      User.new(last_sign_in_at: "1")
  #    end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
  #  end
  #  it "should not allow access to current_sign_in_ip" do
  #    expect do
  #      User.new(current_sign_in_ip: "1")
  #    end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
  #  end
  #  it "should not allow access to last_sign_in_ip" do
  #    expect do
  #      User.new(last_sign_in_ip: "1")
  #    end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
  #  end
  #  it "should not allow access to created_at" do
  #    expect do
  #      User.new(created_at: "1")
  #    end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
  #  end
  #  it "should not allow access to updated_at" do
  #    expect do
  #      User.new(updated_at: "1")
  #    end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
  #  end
  #  it "should not allow access to organization_id" do
  #    expect do
  #      User.new(organization_id: "1")
  #    end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
  #  end
  #
  #end

  describe "when email is not present" do
    before { user.email = " " }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        user.email = invalid_address
        user.should_not be_valid
      end
    end
  end


  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        user.email = valid_address
        user.should be_valid
      end
    end
  end
  describe "when email address is already taken" do

    before do
      @user_with_same_email       = user.dup
      @user_with_same_email.email = user.email.upcase
      @user_with_same_email.save
    end

    it { @user_with_same_email.should_not be_valid }
  end

  describe "when password is not present" do
    before { user.password = user.password_confirmation = " " }
    it { should_not be_valid }
  end


  describe "when password doesn't match confirmation" do
    before { user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "when password confirmation is empty" do
    before { user.password_confirmation = '' }
    it { should_not be_valid }
  end

  describe "when password is too short" do
    before { user.password = user.password_confirmation = "a" * 5 }
    it { should_not be_valid }
  end

  describe "roles" do
    describe "with no roles should not be valid" do
      before do
        user.roles.delete_all
      end
      it { should_not be_valid }
    end
  end

  describe "without associated organization" do
    before { user.organization = nil }
    it { should_not be_valid }
  end

  describe "without first name organization" do
    before { user.first_name = " " }
    it { should_not be_valid }
  end

  describe "user can't be assigned with an admin role if not associated with Owner organization" do
    before do
      user.roles << Role.find_by_name(Role::ADMIN_ROLE_NAME)
    end

    it do
      should_not be_valid
    end
  end

end

