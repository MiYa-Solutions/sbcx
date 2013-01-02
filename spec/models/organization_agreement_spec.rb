require 'spec_helper'

describe OrganizationAgreement do

  let(:new_agreement) { OrganizationAgreement.new }
  let(:agreement_by_cparty) { FactoryGirl.create(:organization_agreement_by_cparty) }

  subject { new_agreement }

  before do

  end

  describe "created by org lifecycle" do
    let!(:agreement_by_org) { FactoryGirl.create(:organization_agreement) }
    let!(:org_user) { agreement_by_org.organization.org_admins.first }
    let!(:cparty_user) { agreement_by_org.counterparty.org_admins.first }

    it "org user should be the only one allowed to update" do
      with_user org_user do
        should_be_allowed_to :update, object: agreement_by_org, context: :agreements
      end

      with_user cparty_user do
        should_not_be_allowed_to :update, object: agreement_by_org, context: :agreements
      end


    end

    it "after submission only the cparty should be allowed to update" do
      with_user org_user do
        agreement_by_org.submit_for_approval
        agreement_by_org.updater    = org_user
        agreement_by_org.updated_at = Time.now
      end

      with_user org_user do
        should_not_be_allowed_to :update, object: agreement_by_org, context: :agreements
      end

      with_user cparty_user do
        should_be_allowed_to :update, object: agreement_by_org, context: :agreements
      end

    end

    describe "after change by the cparty" do
      before do
        with_user org_user do
          agreement_by_org.updater    = org_user
          agreement_by_org.updated_at = Time.now
          agreement_by_org.submit_for_approval

        end
        with_user cparty_user do
          agreement_by_org.updater    = cparty_user
          agreement_by_org.updated_at = Time.now
          agreement_by_org.submit_change
        end
      end
      it "only the org should be allowed to update" do

        with_user org_user do
          should_be_allowed_to :update, object: agreement_by_org, context: :agreements
        end

        with_user cparty_user do
          should_not_be_allowed_to :update, object: agreement_by_org, context: :agreements
        end


      end

      it "the status should be pending org approval" do
        agreement_by_org.status.should be { OrganizationAgreement::STATUS_PENDING_ORG_APPROVAL }
      end
    end


  end

end