# == Schema Information
#
# Table name: agreements
#
#  id                :integer          not null, primary key
#  name              :string(255)
#  counterparty_id   :integer
#  organization_id   :integer
#  description       :text
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  status            :integer
#  counterparty_type :string(255)
#  type              :string(255)
#  creator_id        :integer
#  updater_id        :integer
#  starts_at         :datetime
#  ends_at           :datetime
#  payment_terms     :string(255)
#

require 'spec_helper'

describe OrganizationAgreement do

  let(:new_agreement) { OrganizationAgreement.new }
  let(:agreement_by_cparty) { FactoryGirl.create(:organization_agreement_by_cparty) }

  subject { new_agreement }

  before do

  end

  describe 'payment terms' do

    it 'the available payment terms' do
      new_agreement.class.payment_options.should == [ :cod, :net_10, :net_15, :net_30, :net_60, :net_90 ]
    end


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


    describe "after submission validation" do
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

      # change reason should not be mandatory anymore
      #it "change submission by cparty must include a reason" do
      #  with_user cparty_user do
      #    agreement_by_org.change_reason = nil
      #    expect {
      #      agreement_by_org.submit_change!
      #    }.should raise_error { StateMachine::InvalidTransition }
      #
      #    agreement_by_org.change_reason = "change test"
      #
      #    expect {
      #      agreement_by_org.submit_change!
      #    }.should_not raise_error
      #
      #  end
      #end
      it "change submission by cparty should not force a reason " do
        with_user cparty_user do
          agreement_by_org.change_reason = nil
          expect {
            agreement_by_org.submit_change!
          }.should_not raise_error { StateMachine::InvalidTransition }

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

    describe "submission without posting rules" do

      before do
        with_user org_user do
          agreement_by_org.posting_rules.destroy_all

          agreement_by_org.updater       = org_user
          agreement_by_org.updated_at    = Time.now
          agreement_by_org.change_reason = "test"
        end

      end

      it "should not allow the transition " do
        expect {
          agreement_by_org.submit_for_approval!
        }.should raise_error { StateMachine::InvalidTransition }
      end

      it "should have an error on posting rules" do
        agreement_by_org.submit_for_approval
        agreement_by_org.errors[:posting_rules].should_not be_nil
      end

    end

    describe "after activation" do
      before do
        with_user org_user do
          agreement_by_org.change_reason = "Stam"
          agreement_by_org.submit_for_approval
        end

        with_user cparty_user do
          agreement_by_org.change_reason = "Stam"
          agreement_by_org.accept
        end


      end

      it "acceptance should fail as only one active agreement should be allowed in a specific period" do
        new_agr               = FactoryGirl.create(:organization_agreement, organization: agreement_by_org.organization, counterparty: agreement_by_org.counterparty)
        new_agr.change_reason = "Stam"
        new_agr.submit_for_approval
        new_agr.accept
        Rails.logger.debug { "The status of new_agr is: #{new_agr.status_name}" }
        new_agr.errors[:starts_at].should_not be_nil
      end

      it "an account owned by the first member should be created" do
        Account.where("organization_id = #{agreement_by_org.organization_id} AND accountable_id = #{agreement_by_org.counterparty_id} AND accountable_type = 'Organization'").should exist
      end
      it "an account owned by the second member should be created" do
        Account.where("organization_id = #{agreement_by_org.counterparty_id} AND accountable_id = #{agreement_by_org.organization_id} AND accountable_type = 'Organization'").should exist
      end
      it "cancel is the only available operation" do
        agreement_by_org.status_events.size.should be 1
        agreement_by_org.status_events.should include(:cancel)

      end
      it "no changes are allowed except for ends_at" do
        agreement_by_org.update_attributes(name: "New Name")
        agreement_by_org.should_not be_valid
        agreement_by_org.errors[:status].should_not be_nil
      end

      it "ends_at can be changed" do
        agreement_by_org.ends_at = Time.now
        agreement_by_org.should be_valid
      end

      describe 'changing the end date' do
        before do
          FactoryGirl.create(:my_service_call, organization: agreement_by_org.organization, subcontractor: agreement_by_org.counterparty.becomes(Subcontractor))
          agreement_by_org.update_attributes(ends_at: 1.day.ago)
        end
        it "ends_at can't be set to a date earlier than the last job" do


          agreement_by_org.should_not be_valid

        end
      end

      it "can't add a posting rule" do
        rule = FactoryGirl.build(:profit_split, agreement: agreement_by_org)
        agreement_by_org.posting_rules << rule

        rule.should_not be_valid
        rule.errors[:agreement].should_not be_nil
      end

      it "can't change a posting rule" do
        rule      = agreement_by_org.posting_rules.first
        rule.rate = 34
        rule.should_not be_valid
        rule.errors[:agreement].should_not be_nil
      end

      describe "adding a new agreement" do
        before do
          agreement_by_org.accept
        end

        let(:org) { agreement_by_org.organization }
        let(:counterparty) { agreement_by_org.counterparty }
        let(:another_agreement) { FactoryGirl.create(:organization_agreement, organization: org, counterparty: counterparty) }

        it 'the new agreement is not valid as it overlaps the agreement period' do
          another_agreement.change_reason = "stam"
          another_agreement.submit_for_approval
          another_agreement.accept
          another_agreement.errors[:starts_at].should_not be_nil
        end

        it "new agreement is set to approved_pending when dates don't overlap" do
          another_agreement.starts_at = agreement_by_org.ends_at + 1.day
          another_agreement.save
          another_agreement.change_reason = "stam"
          another_agreement.submit_for_approval
          another_agreement.accept
          another_agreement.status_name.should be(:approved_pending)
        end


      end

    end


  end

end
