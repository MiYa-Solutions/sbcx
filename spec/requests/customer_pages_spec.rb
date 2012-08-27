require 'spec_helper'
require 'capybara/rspec'


describe "Customer Pages" do

  let!(:org_admin_user) do
    without_access_control do
      FactoryGirl.create(:org_admin)
    end

  end

  let!(:org) { org_admin_user.organization }


  before(:each) do
    sign_in org_admin_user
  end

  subject { page }

  describe "with Org Admin" do

    describe "Customer Index" do
      before do
        with_user(org_admin_user) do
          visit customers_path
        end

      end

      describe "with no customers" do
        it { should have_selector('span.alert-info') }
        it { should have_selector('#new-customer-button') }
      end

      describe "with a customer" do
        let!(:customer) { FactoryGirl.create(:customer, organization: org, name: "moshe") }

        before { visit customers_path }

        after do
          clean org
        end

        it { should have_selector('table#customers_search_results tr', count: 2) }
        it { should have_selector('table#customers_search_results td', text: customer.name) }

        describe "search", js: true do
          self.use_transactional_fixtures = false

          describe "find it's own customers", js: true do
            self.use_transactional_fixtures = false


            before do
              visit customers_path
              fill_in 'search', with: customer.name
              click_button 'customer-search-button'
            end

            after do
              clean org
            end

            it { should have_selector('table#customers_search_results tr', count: 2) }
            it { should have_selector('table#customers_search_results td', text: customer.name) }
          end

          describe "should not find customers of other members", js: true do
            self.use_transactional_fixtures = false

            let(:other_customer) { FactoryGirl.create(:customer, name: "not my moshe") }

            before do

              visit customers_path
              fill_in 'search', with: other_customer.name
              click_button 'customer-search-button'
            end

            after do
              clean org
              clean other_customer.organization
            end

            it { should_not have_selector('table#customers_search_results tr', count: 2) }
            it { should_not have_selector('table#customers_search_results td', text: other_customer.name) }

          end


        end


      end


    end
  end


end



