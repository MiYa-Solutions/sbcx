require 'spec_helper'
require 'capybara/rspec'


describe "Agreement Pages" do
  # ==============================================================
  # data elements to inspect
  # ==============================================================
  status              = 'span#agreement_status'
  provider_name       = 'provider_name'

  # ==============================================================
  # buttons to click and inspect
  # ==============================================================
  create_provider_btn = 'create_provider_btn'

  subject { page }

  describe "with Org Admin", js: true do
    self.use_transactional_fixtures = false

    let(:org_admin_user) { FactoryGirl.create(:member_admin, roles: [Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME), Role.find_by_name(Role::DISPATCHER_ROLE_NAME), Role.find_by_name(Role::TECHNICIAN_ROLE_NAME)]) }
    let(:org_admin_user2) { FactoryGirl.create(:member_admin, roles: [Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME), Role.find_by_name(Role::DISPATCHER_ROLE_NAME), Role.find_by_name(Role::TECHNICIAN_ROLE_NAME)]) }
    let(:org) { org_admin_user.organization }
    let(:org2) { org_admin_user2.organization }

    before do
      in_browser(:org) do
        sign_in org_admin_user
      end

      in_browser(:org2) do
        sign_in org_admin_user2
      end
    end

    after do
      clean org unless org.nil?
      clean org2 unless org2.nil?
    end

    describe "adding a local provider" do

      before do
        in_browser(:org) do
          with_user(org_admin_user) do
            visit new_provider_path
            fill_in provider_name, with: "test prov"
            click_button create_provider_btn
          end
        end
      end

      let(:agreement) { Agreement.last }

      it "should redirect to the agreement edit page" do
        in_browser(:org) do
          current_path.should == edit_agreement_path(agreement)
        end

      end

    end


  end


end
