require 'spec_helper'
require 'capybara/rspec'


describe "Provider Pages" do

  let(:org_admin_user) { FactoryGirl.create(:org_admin) }

  let(:org) { org_admin_user.organization }

  before(:each) do
    sign_in org_admin_user
  end

  subject { page }

  describe "with Org Admin" do

    describe "My Providers Index" do
      before { visit providers_path }

      describe " With No Providers" do
        it { should have_selector('#empty_search_result_notice') }
        it { should have_selector('#new-provider-button') }

      end

      describe "With Many Local Providers" do
        before do # the high level example
          30.times { org.providers << FactoryGirl.create(:provider) }
          visit providers_path
        end


        it { should have_selector('#providers_search_results') }
        it { should have_selector('#new-provider-button') }

        describe "search results", js: true do
          self.use_transactional_fixtures = false

          after do
            org.providers.each do |prov|
              prov.destroy
            end

            org.providers.destroy_all

            org.users.each do |usr|
              usr.destroy
            end

            org.users.destroy_all
            org.destroy

          end

          describe "to include providers who are sbcx memebers", js: true do

            let!(:member_provider) { FactoryGirl.create(:member) }

            before do #the actual search
              fill_in 'search', with: member_provider.name
              click_button 'provider-search-button'
            end

            after do
              member_provider.providers.each do |prov|
                prov.destroy
              end

              member_provider.providers.destroy_all

              member_provider.users.each do |usr|
                usr.destroy
              end

              member_provider.users.destroy_all
              member_provider.destroy

            end

            it { should have_content(member_provider.name) }
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
              another_member.providers.each do |prov|
                prov.destroy
              end
              another_member.users.each do |usr|
                usr.destroy
              end
              another_member.providers.destroy_all
              another_member.users.destroy_all
              another_member.destroy
            end

            it { should_not have_content("Other Member's Local Provider") }
          end
        end
      end

    end

  end
end