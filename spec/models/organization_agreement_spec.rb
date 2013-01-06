# == Schema Information
#
# Table name: agreements
#
#  id                :integer         not null, primary key
#  name              :string(255)
#  counterparty_id   :integer
#  organization_id   :integer
#  description       :text
#  created_at        :datetime        not null
#  updated_at        :datetime        not null
#  status            :integer
#  counterparty_type :string(255)
#  type              :string(255)
#  creator_id        :integer
#  updater_id        :integer
#

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

    describe "after submission only the cparty should be allowed to update" do
      before do
        with_user org_user do
          agreement_by_org.updater       = org_user
          agreement_by_org.updated_at    = Time.now
          agreement_by_org.change_reason = "test"
          agreement_by_org.submit_for_approval
        end

      end

      it "status should be pending cparty approval" do
        agreement_by_org.status.should be { OrganizationAgreement::STATUS_PENDING_CPARTY_APPROVAL }
      end

      it "after submission only the cparty should be allowed to update" do
        with_user org_user do
          should_not_be_allowed_to :update, object: agreement_by_org, context: :agreements
        end

        with_user cparty_user do
          should_be_allowed_to :update, object: agreement_by_org, context: :agreements
        end

      end

      it "change submission by cparty must include a reason" do
        with_user cparty_user do
          agreement_by_org.change_reason = nil
          expect {
            agreement_by_org.submit_change!
          }.should raise_error { StateMachine::InvalidTransition }

          agreement_by_org.change_reason = "change test"

          expect {
            agreement_by_org.submit_change!
          }.should_not raise_error

        end
      end

      describe "after change by the cparty" do
        before do
          with_user cparty_user do
            agreement_by_org.updater    = cparty_user
            agreement_by_org.updated_at = Time.now
            agreement_by_org.submit_change
          end
        end

        it "the status should be pending organization approval" do
          agreement_by_org.status.should be { OrganizationAgreement::STATUS_PENDING_ORG_APPROVAL }
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

end
