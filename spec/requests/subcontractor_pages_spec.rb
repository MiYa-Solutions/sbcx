require 'spec_helper'
require 'capybara/rspec'

describe "Subcontractor pages" do

  let(:org_admin_user) { FactoryGirl.create(:org_admin) }
  let(:org) { org_admin_user.organization }

  before(:each) do
    sign_in org_admin_user
  end

  subject { page }

  describe "with Org Admin" do

    describe "My Subcontractors Index" do

      before do
        with_user(org_admin_user) do
          visit subcontractors_path
        end

      end

      describe "With No Subcontractors" do
        it { should have_selector('#empty_search_result_notice') }
        it { should have_selector('#new-subcontractor-button') }

      end

      describe "With Many Local Subcontractors" do
        let!(:member) { FactoryGirl.create(:member_admin).organization }

        before do # the high level example
          2.times { org.subcontractors << FactoryGirl.create(:subcontractor) }
          visit subcontractors_path
        end

        after { clean member }

        it { should have_selector('#subcontractors_search_results') }
        it { should have_selector('#new-subcontractor-button') }
        # don't show members that are not associated with logged in org upon accessing the index
        it { should_not have_selector('.member_label') }

        describe "search results", js: true do
          self.use_transactional_fixtures = false

          after do
            clean org
          end

          describe "to include subcontractors who are sbcx memebers" do

            let!(:member) { FactoryGirl.create(:member_admin).organization }

            before do #the actual search
              member.name = "moshe"
              member.save
              fill_in 'search', with: member.name
              click_button 'subcontractor-search-button'
            end

            after do
              clean member
            end

            it { should_not have_selector('table#subcontractors_search_results tr', count: 2) }
            it { should have_selector('table#subcontractors_search_results td', text: member.name) }

          end

          describe "show a mix of local and similar public subcontractors" do
            #pending "implementation"
            let!(:member) { FactoryGirl.create(:member_admin).organization }

            before do # the high level example
              2.times { org.subcontractors << FactoryGirl.create(:subcontractor) }
              visit subcontractors_path
              fill_in 'search', with: member.name
              click_button 'subcontractor-search-button'
              click_button "#{member.id}-add-sbcx-subcontractor"
              visit subcontractors_path
            end

            after do
              clean member
            end

            it { should have_selector('table#subcontractors_search_results tr', count: 6) }
            it { should have_selector('table#subcontractors_search_results td', text: member.name) }
            it { should have_selector('.member_label') }

          end

          describe " it should not show local subcontractors of other members", js: true do
            let(:another_member) { FactoryGirl.create(:member) }

            before do # before searching for another prov
              another_member.providers << FactoryGirl.create(:provider, name: "Other Member's Local Subcontractor")
              fill_in 'search', with: "Other Member's Local Subcontractor"
              click_button 'subcontractor-search-button'
            end

            after do
              clean another_member
            end

            it { should_not have_content("Other Member's Local Subcontractor") }
          end
        end
      end
    end

    describe "Add Subcontractor" do
      let(:new_prov) { FactoryGirl.build(:subcontractor) }

      before do
        visit new_subcontractor_path
      end


      it "should add local subcontractor successfully" do
        expect do
          fill_in 'subcontractor_name', with: new_prov.name
          click_button 'create_subcontractor_btn'

        end.to change(Organization, :count).by(1)
      end

    end


  end
end

