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

      before { visit subcontractors_path }

      describe " With No Subcontractors" do
        it { should have_selector('#empty_search_result_notice') }
        it { should have_selector('#new-subcontractor-button') }

      end

      describe "With Many Local Subcontractors" do
        let!(:member) { FactoryGirl.create(:member_admin).organization }
        before do # the high level example
          2.times { org.subcontractors << FactoryGirl.create(:subcontractor) }
          visit subcontractors_path
        end

        after do
          clean member
        end


        it { should have_selector('#subcontractors_search_results') }
        it { should have_selector('#new-subcontractor-button') }
        # don't show members that are not associated with logged in org upon accessing the index
        it { should_not have_selector('.member_label') }

        describe "search results", js: true do
          self.use_transactional_fixtures = false

          after do
            clean org
          end

          describe "to include subcontractors who are sbcx memebers", js: true do

            let!(:member) { FactoryGirl.create(:member_admin).organization }

            before do #the actual search
              fill_in 'search', with: member.name
              click_button 'subcontractor-search-button'
            end

            after do
              clean member
            end
            it { should have_selector('table#subcontractors_search_results tr', count: 2) }
            it { should have_selector('table#subcontractors_search_results td', text: member.name) }

          end
          describe "show a mix of local and similar public subcontractors" do
            pending "implementation"
          end
          describe " it should not show local subcontractors of other members", js: true do
            let(:another_member) { FactoryGirl.create(:member) }
            let(:subcontractor) { FactoryGirl.build(:subcontractor, name: "Other Member's Local Provider") }

            before do # before searching for another prov
              another_member.subcontractors << subcontractor
              fill_in 'search', with: subcontractor.name
              click_button 'subcontractor-search-button'
            end


            after do
              clean another_member
            end

            it { should_not have_content(subcontractor.name) }
          end
        end
      end

    end

    describe "Add Subcontractor" do
      before do
        visit new_subcontractor_path
      end

      let(:new_prov) { FactoryGirl.build(:subcontractor) }

      it "should add local subcontractor successfully" do
        expect do
          fill_in 'subcontractor_name', with: new_prov.name
          click_button 'create_subcontractor_btn'

        end.to change(Organization, :count).by(1)
      end

    end


  end

end