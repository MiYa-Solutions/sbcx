require 'spec_helper'
require 'capybara/rspec'


describe "Affiliate Pages" do


  let(:org_admin_user) do
    without_access_control do
      FactoryGirl.create(:org_admin)
    end

  end

  let(:org) { org_admin_user.organization }


  before(:each) do
    sign_in org_admin_user
  end

  subject { page }

  describe "with Org Admin" do

    describe "Affiliate Index" do
      before do
        with_user(org_admin_user) do
          visit affiliates_path
        end

      end

      describe " With No Affiliates" do
        it { should have_selector('#empty_search_result_notice') }
        it { should have_selector('#new-affiliate-button') }

      end

      describe "With Many Local Providers" do
        let!(:member) { FactoryGirl.create(:member_admin).organization }

        before do # the high level example
          2.times { org.providers << FactoryGirl.create(:provider) }
          visit affiliates_path
        end

        after { clean member }


        it { should have_selector('#affiliates_search_results') }
        it { should have_selector('#new-affiliate-button') }
        # don't show members that are not associated with logged in org upon accessing the index
        it { should_not have_selector('#affiliates_search_results .member_label') }

        describe "search results", js: true do
          self.use_transactional_fixtures = false

          after do
            clean org
          end

          describe "to include affiliates who are sbcx members", js: true do

            let!(:member) { FactoryGirl.create(:member_admin).organization }

            before do #the actual search
              member.name = "moshe"
              member.save
              fill_in 'search', with: member.name
              click_button 'affiliate-search-button'
            end

            after do
              clean member
            end

            it { should have_selector('table#affiliates_search_results tbody#affiliates tr', count: 1) }
            it { should have_selector('table#affiliates_search_results tbody#affiliates td', text: member.name) }


          end

          describe "show a mix of local and similar public providers", js: true do
            pending "determine the behavior and implement test"
            #let!(:member) { FactoryGirl.create(:member_admin).organization }
            #
            #before do # the high level example
            #  2.times { org.providers << FactoryGirl.create(:provider) }
            #  visit affiliates_path
            #  fill_in 'search', with: member.name
            #  click_button 'affiliate-search-button'
            #  click_button "#{member.id}-add-sbcx-member"
            #  visit affiliates_path
            #end
            #
            #after do
            #  clean member
            #end
            #
            #it { should have_selector('table#affiliates_search_results tr', count: 6) }
            #it { should have_selector('table#affiliates_search_results td', text: member.name) }
            #it { should have_selector('.member_label') }

          end

          describe " it should not show local providers of other members", js: true do
            let(:another_member) { FactoryGirl.create(:member) }

            before do # before seraching for another prov
              another_member.providers << FactoryGirl.create(:provider, name: "Other Member's Local Provider")
              fill_in 'search', with: "Other Member's Local Provider"
              click_button 'affiliate-search-button'
            end


            after do
              clean another_member
            end

            it { should_not have_content("Other Member's Local Provider") }
          end
        end
      end

      it "email in table should be a link to an email message"
      it "should show name, phone, email, balance"
      it "should not have 'Archive"
      it "should have pagination"

    end

    describe "Add Affiliate" do
      before do
        visit new_affiliate_path
      end

      let!(:new_prov) { FactoryGirl.build(:provider) }

      it "should add local provider successfully" do
        expect do
          fill_in 'affiliate_name', with: new_prov.name
          check 'affiliate_organization_role_ids_1'
          click_button 'create_affiliate_btn'

        end.to change(Organization, :count).by(1)

      end

    end

    describe "Update Affiliate" do

      let(:new_prov) { FactoryGirl.build(:provider) }

      before do
        org.providers << new_prov
        org.save
        visit edit_affiliate_path(new_prov.id)
      end


      it { should have_content(new_prov.name) }

      describe "successful update" do
        before do
          fill_in 'affiliate_company', with: "new company"
          click_button 'save_affiliate_btn'
        end

        it { should have_selector('div.alert-notice') }
        it { should have_content('new company') }
      end

      describe "of another member" do

      end

    end

  end

  describe "with dispatcher" do
    pending "implement test to verify authorization"
  end
end
