require 'spec_helper'
require 'capybara/rspec'


describe "My Users pages" do

  describe "with Org Admin" do

    describe "my employees (index)" do
      it "should show have a search box"
      it "should show the employee name"
      it "should show the employee email"
      it "should show the employee phone"
      it "should show the debt balance"
      it "should have edit and show actions"
      it "should have paginations"
      it "should show 10 records per page"

    end

    describe "my employee (show)" do

      it "should show a status"
      it "should have a reset password option"
      it "should show the balance"
      it "should show the agreements"
      it "should show open tickets"
    end


  end

end