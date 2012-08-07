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

  it { should be_valid }
  it "saved successfully" do
    expect {
      user.save
    }.to change { User.count }.by(1)
  end

  describe "accessible attributes" do
    it "should not allow access to last_sign_ip" do
      expect do
        User.new(last_sign_in_ip: "1")
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
    it "should not allow access to current_sign_in_ip" do
      expect do
        User.new(current_sign_in_ip: "1")
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
    it "should not allow access to encrypted_password" do
      expect do
        User.new(encrypted_password: "1")
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
    it "should not allow access to reset_password_sent_at" do
      expect do
        User.new(reset_password_sent_at: "1")
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
    it "should not allow access to remember_created_at" do
      expect do
        User.new(remember_created_at: "1")
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
    it "should not allow access to sign_in_count" do
      expect do
        User.new(sign_in_count: "1")
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
    it "should not allow access to current_sign_in_at" do
      expect do
        User.new(current_sign_in_at: "1")
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
    it "should not allow access to last_sign_in_at" do
      expect do
        User.new(last_sign_in_at: "1")
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
    it "should not allow access to current_sign_in_ip" do
      expect do
        User.new(current_sign_in_ip: "1")
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
    it "should not allow access to last_sign_in_ip" do
      expect do
        User.new(last_sign_in_ip: "1")
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
    it "should not allow access to created_at" do
      expect do
        User.new(created_at: "1")
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
    it "should not allow access to updated_at" do
      expect do
        User.new(updated_at: "1")
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
    it "should not allow access to organization_id" do
      expect do
        User.new(organization_id: "1")
      end.should raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end

  end

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
      @user_with_same_email = user.dup
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

  describe "user can't be assigned with an admin role if not associated with Owner organization" do
    before do
      user.roles << Role.find_by_name(Role::ADMIN_ROLE_NAME)
    end

    it do
      should_not be_valid
    end
  end


end

#describe "micropost associations" do
#
#  before { @user.save }
#  let!(:older_micropost) do
#    FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
#  end
#  let!(:newer_micropost) do
#    FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
#  end
#
#  it "should have the right microposts in the right order" do
#    @user.microposts.should == [newer_micropost, older_micropost]
#  end
#
#  it "should destroy associated microposts" do
#    microposts = @user.microposts
#    @user.destroy
#    microposts.each do |micropost|
#      Micropost.find_by_id(micropost.id).should be_nil
#    end
#  end
#
#  describe "status" do
#    let(:unfollowed_post) do
#      FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
#    end
#    let(:followed_user) { FactoryGirl.create(:user) }
#
#    before do
#      @user.follow!(followed_user)
#      3.times { followed_user.microposts.create!(content: "Lorem ipsum") }
#    end
#
#    its(:feed) { should include(older_micropost) }
#    its(:feed) { should include(newer_micropost) }
#    its(:feed) { should_not include(unfollowed_post) }
#    its(:feed) do
#      followed_user.microposts.each do |micropost|
#        should include(micropost)
#      end
#    end
#  end
#end
#
#describe "following" do
#  let(:other_user) { FactoryGirl.create(:user) }
#  before do
#    @user.save
#    @user.follow!(other_user)
#  end
#
#  it { should be_following(other_user) }
#  its(:followed_users) { should include(other_user) }
#
#  describe "followed user" do
#    subject { other_user }
#    its(:followers) { should include(@user) }
#  end
#
#  describe "and unfollowing" do
#    before { @user.unfollow!(other_user) }
#
#    it { should_not be_following(other_user) }
#    its(:followed_users) { should_not include(other_user) }
#  end
#end




