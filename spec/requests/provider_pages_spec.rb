require 'spec_helper'
require 'capybara/rspec'


describe "Provider Pages" do


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

    describe "My Providers Index" do
      before do
        with_user(org_admin_user) do
          visit providers_path
        end

      end

      describe " With No Providers" do
        it { should have_selector('#empty_search_result_notice') }
        it { should have_selector('#new-provider-button') }

      end

      describe "With Many Local Providers" do
        let!(:member) { FactoryGirl.create(:member_admin).organization }

        before do # the high level example
          2.times { org.providers << FactoryGirl.create(:provider) }
          visit providers_path
        end

        after { clean member }


        it { should have_selector('#providers_search_results') }
        it { should have_selector('#new-provider-button') }
        # don't show members that are not associated with logged in org upon accessing the index
        it { should_not have_selector('.member_label') }

        describe "search results", js: true do
          self.use_transactional_fixtures = false

          after do
            clean org
          end

          describe "to include providers who are sbcx memebers", js: true do

            let!(:member) { FactoryGirl.create(:member_admin).organization }

            before do #the actual search
              fill_in 'search', with: member.name
              click_button 'provider-search-button'
            end

            after do
              clean member
            end

            it { should have_selector('table#providers_search_results tr', count: 2) }
            it { should have_selector('table#providers_search_results td', text: member.name) }

          end
          describe "show a mix of local and similar public providers" do
            pending "implementation"
          end
          describe " it should not show local providers of other members", js: true do
            let(:another_member) { FactoryGirl.create(:member) }

            before do # before seraching for another prov
              another_member.providers << FactoryGirl.create(:provider, name: "Other Member's Local Provider")
              fill_in 'search', with: "Other Member's Local Provider"
              click_button 'provider-search-button'
            end


            after do
              clean another_member
            end

            it { should_not have_content("Other Member's Local Provider") }
          end
        end
      end

    end

    describe "Add Provider" do
      before do
        visit new_provider_path
      end

      let(:new_prov) { FactoryGirl.build(:provider) }

      it "should add local provider successfully" do
        expect do
          fill_in 'provider_name', with: new_prov.name
          click_button 'create_provider_btn'

        end.to change(Organization, :count).by(1)
      end

    end

    describe "Update Provider" do

      let(:new_prov) { FactoryGirl.build(:provider) }

      before do
        org.providers << new_prov
        org.save
        visit edit_provider_path(new_prov.id)
      end


      it { should have_content(new_prov.name) }

      describe "successful update" do
        before do
          fill_in 'provider_company', with: "new company"
          click_button 'save_provider_btn'
        end

        it { should have_selector('div.alert-notice') }
        it { should have_content('new company') }
      end

    end

  end

  describe "with dispatcher" do
    pending "implement test to verify authorization"
  end
end