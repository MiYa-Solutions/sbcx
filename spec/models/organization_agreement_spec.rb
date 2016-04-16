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
require 'paper_trail/frameworks/rspec'

describe OrganizationAgreement do

  let(:new_agreement) { OrganizationAgreement.new }
  let(:agreement_by_cparty) { FactoryGirl.create(:organization_agreement_by_cparty) }

  subject { new_agreement }

  describe 'association' do
    it { should have_many(:subcon_tickets) }
    it { should have_many(:prov_tickets) }
  end

  describe 'payment terms' do
    it 'the available payment terms' do
      new_agreement.class.payment_options.should == { cod: 0, net_10: 10, net_15: 15, net_30: 30, net_60: 60, net_90: 90 }
    end
  end

  describe 'when agreement is created by the prov (organization)' do

    describe 'created by org lifecycle', :versioning => true do
      let(:agreement_by_org) { FactoryGirl.create(:organization_agreement) }
      let(:org_user) { agreement_by_org.organization.org_admins.first }
      let(:cparty_user) { agreement_by_org.counterparty.org_admins.first }


      it 'org user should be the only one allowed to update' do
        with_user org_user do
          should_be_allowed_to :update, object: agreement_by_org, context: :agreements
        end

        with_user cparty_user do
          should_not_be_allowed_to :update, object: agreement_by_org, context: :agreements
        end
      end

      context 'ensure AgrNewSubconEvent is created' do
        let(:new_agr_event) { AgrNewSubconEvent.find_by_eventable_id_and_eventable_type(agreement_by_org.id, 'Agreement') }

        it 'expect the event to exist' do
          with_user org_user do
            expect(new_agr_event).to_not be_nil
          end
        end
      end


      describe 'after submission validation', :versioning => true do
        before do
          with_user org_user do
            agreement_by_org.updater       = org_user
            agreement_by_org.updated_at    = Time.now
            agreement_by_org.change_reason = "test"
            agreement_by_org.submit_for_approval
          end

        end

        context 'ensure AgrSubmittedEvent is created' do
          let(:submission_event) { AgrSubmittedEvent.find_by_eventable_id_and_eventable_type(agreement_by_org.id, 'Agreement') }
          # before do
          #   with_user org_user do
          #     submission_event
          #   end
          # end

          it 'expect the event to exist' do
            expect(submission_event).to_not be_nil
          end
        end

        it 'status should be pending cparty approval' do
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
            }.to_not raise_error { StateMachine::InvalidTransition }

            agreement_by_org.change_reason = "change test"

            expect {
              agreement_by_org.submit_change!
            }.to_not raise_error

          end
        end

        describe 'after change by the cparty', :versioning => true do
          before do
            with_user cparty_user do
              agreement_by_org.updater    = cparty_user
              agreement_by_org.updated_at = Time.now
              agreement_by_org.submit_change
            end

          end

          it 'the status should be pending organization approval' do
            agreement_by_org.status.should be { OrganizationAgreement::STATUS_PENDING_ORG_APPROVAL }
          end

          it 'only the org should be allowed to update' do

            with_user org_user do
              should_be_allowed_to :update, object: agreement_by_org, context: :agreements
            end

            with_user cparty_user do
              should_not_be_allowed_to :update, object: agreement_by_org, context: :agreements
            end


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
          expect do
            agreement_by_org.submit_for_approval!
          end.to raise_error { StateMachine::InvalidTransition }
        end

        it "should have an error on posting rules" do
          agreement_by_org.submit_for_approval
          agreement_by_org.errors[:posting_rules].should_not be_nil
        end

      end

      describe 'after acceptance', :versioning => true do
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
            job                  = FactoryGirl.create(:my_service_call, organization: agreement_by_org.organization, subcontractor: agreement_by_org.counterparty.becomes(Subcontractor))
            job.subcon_agreement = agreement_by_org
            job.save!
            agreement_by_org.update_attributes(ends_at: 1.day.ago)
          end
          it "ends_at can't be set to a date earlier than the last job" do


            agreement_by_org.reload.should_not be_valid

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

        it 'cancelling the agreement is successful' do
          agreement_by_org.cancel!
          expect(agreement_by_org).to be_canceled
        end
      end

      context 'when negotiating', :versioning => true do

        before do
          with_user org_user do
            agreement_by_org.name          = 'Original Name'
            agreement_by_org.change_reason = 'Reason for creation'
            agreement_by_org.submit_for_approval
          end

          with_user cparty_user do
            agreement_by_org.name          = 'Changed Name'
            agreement_by_org.change_reason = 'Reason for changed name'
            agreement_by_org.submit_change
          end
        end


        it 'acceptance is not allowed after making a change' do
          with_user org_user do
            agreement_by_org.name = 'Changed Name'
            agreement_by_org.save
            expect(agreement_by_org.can_accept?).to be_false
          end

        end

        context 'when the counterparty submits a change ' do
          let(:change_event) { AgrChangeSubmittedEvent.find_by_eventable_id_and_eventable_type(agreement_by_org.id, 'Agreement') }

          it 'the agreement should have a AgrChangeSubmittedEvent' do
            expect(change_event).to_not be_nil
          end


          it 'the AgrChangeSubmittedEvent description should show the difference between both versions' do
            expect(change_event.reload.description).to include('agr_diff_table')
          end
        end

        context 'when deleting the rules' do

          before do
            with_user org_user do
              agreement_by_org.rules.destroy_all
            end
          end

          it 'name should not be allowed to change a rule must be defined first' do
            with_user org_user do
              agreement_by_org.name = 'a new name'
              expect(agreement_by_org).to_not be_valid
            end

          end


        end

        context 'when the contractor rejects the changes' do
          before do
            with_user org_user do
              agreement_by_org.update_attributes(status_event: 'reject', change_reason: 'the rejection reason') unless example.metadata[:skip_reject]
            end
          end

          it 'rejection should be successful' do
            expect(agreement_by_org).to be_rejected_by_org
          end

          it 'the rejection reason should propagate to the event' do
            expect(agreement_by_org.events.first.change_reason).to eq 'the rejection reason'
          end

          it 'should trigger the rejected event', skip_reject: true do
            event = mock_model(AgrChangeRejectedEvent, :eventable_id= => 1, :[]= => true, save: true)
            AgrChangeRejectedEvent.stub(new: event)
            AgrChangeRejectedEvent.should_receive(:new)
            agreement_by_org.update_attributes(status_event: 'reject', change_reason: 'the rejection reason')
          end
        end

      end
    end
  end

  describe 'with local provider' do
    let(:agr_with_local_subcon) { FactoryGirl.create(:organization_agreement, counterparty: FactoryGirl.create(:subcontractor)) }

    it 'activation with no rules should not be allowed' do
      agr_with_local_subcon.rules.destroy_all
      expect do
        agr_with_local_subcon.activate!
      end.to raise_error(StateMachine::InvalidTransition)
      Rails.logger.debug { "agr_with_local_subcon status: #{agr_with_local_subcon.status_name}" }
    end

  end
end

