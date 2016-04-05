require 'spec_helper'
require 'capybara/rspec'


describe "Authorization" do

  let(:mem1_user) { FactoryGirl.create(:member_admin) }
  let(:mem2_user) { FactoryGirl.create(:member_admin) }

  before do
    sign_in mem1_user
  end

  subject { page }

  describe "Customers" do

    describe "one member should not see customers of another member" do
      let(:other_customer) { FactoryGirl.create(:customer, organization: mem2_user.organization) }

      it "should not find customer of another member" do
        visit customer_path(other_customer)
        should have_selector('.alert-error')
      end


    end

  end
end
