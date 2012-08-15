require 'spec_helper'
require 'capybara/rspec'


describe "Sign Up" do

  let!(:provider) { FactoryGirl.build(:org_with_providers) }
  let!(:user) { FactoryGirl.build(:admin, organization: provider) }

  subject { page }

  it "should do something" do

    #To change this template use File | Settings | File Templates.
    true.should == false
  end
end