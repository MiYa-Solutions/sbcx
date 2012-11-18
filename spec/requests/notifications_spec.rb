require 'spec_helper'

# ==============================================================
# data elements to inspect
# ==============================================================

notification_counter = 'span#notification-counter.label'

describe "Notifications" do
  let(:org_admin_user) { FactoryGirl.create(:member_admin) }
  let(:org_admin_user2) { FactoryGirl.create(:member_admin) }
  let(:org_admin_user3) { FactoryGirl.create(:member_admin) }
  let(:org) { org_admin_user.organization }
  let(:org2) { org_admin_user2.organization }
  let(:org3) { org_admin_user3.organization }

  let(:provider) {
    prov = FactoryGirl.create(:provider)
    org.providers << prov
    org.save!
    prov
  }

  let(:subcontractor) {
    subcontractor = org2.becomes(Subcontractor)
    org.subcontractors << subcontractor
    subcontractor
  }

  let(:customer) { FactoryGirl.create(:customer, organization: org) }
  before do
    org.providers << org2.becomes(Provider)
    in_browser(:org) do
      sign_in org_admin_user
    end

    in_browser(:org2) do
      sign_in org_admin_user2
    end


  end

  describe "Welcome page" do
    it "should show the number of unread notifications" do
      visit user_root_path
      should have_selector notification_counter
    end
  end
end
