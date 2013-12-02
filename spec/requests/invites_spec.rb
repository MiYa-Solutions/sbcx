require 'spec_helper'
#require 'support/affiliate_page_selectors'

describe 'Invite Pages' do
  let(:org_user) { FactoryGirl.create(:member_admin) }
  let(:org) { org_user.organization }
  let(:aff_user) { FactoryGirl.create(:member_admin) }
  let(:affiliate) { aff_user.organization }

  before do
    in_browser(:org) do
      sign_in org_user
    end

    in_browser(:aff) do
      sign_in aff_user
    end
  end

  context 'when org invites the affiliate' do

    before do
      in_browser(:org) do
        visit affiliate_path(affiliate)
      end
    end


    it 'should show an invite button' do
      expect(page).to have_link(AFF_INVITE_BTN)
    end

    context 'when viewing the new invite form' do
      before do
        in_browser(:org) do
          click_on(AFF_INVITE_BTN)
        end
      end

      it 'should show the new invite form' do
        expect(page).to have_selector(AFF_INVITE_FORM)
      end

      context 'when creating the invite' do
        let(:invite) { Invite.find_by_organization_id_and_affiliate_id(org.id, affiliate.id) }
        before do
          fill_in INVITE_INPUT_MESSAGE, with: 'Test message'
          click_button INVITE_BTN_CREATE
        end

        it 'should be successful' do
          expect(page).to have_success_message
        end

        it 'should create a notification for the affiliate' do
          in_browser(:aff) do
            visit notifications_path
          end

          expect(page).to have_notification(NewInviteNotification, invite)
        end

        it 'the invite should have an accept and decline buttons' do
          in_browser(:aff) do
            visit invite_path(invite)
          end

          expect(page).to have_button(INVITE_BTN_ACCEPT)
          expect(page).to have_button(INVITE_BTN_DECLINE)
        end

        context 'when the affiliate accepts the invite' do

          before do
            in_browser(:aff) do
              visit invite_path(invite)
              click_button INVITE_BTN_ACCEPT
            end
          end

          it 'status should be set to accepted' do
            expect(invite.reload).to be_accepted
          end


          it 'should create a flat fee agreement' do
            agr_list = Agreement.our_agreements(org, affiliate).all
            expect(agr_list.size).to eq 2

            agr_list.each do |agr|

              expect(agr.status).to eq Agreement::STATUS_ACTIVE

              rule_list = agr.rules
              expect(rule_list.size).to eq 1

              rule = rule_list.first
              expect(rule).to be_instance_of(FlatFee)
            end
          end

          it 'should create two accounts' do
            expect(Account.for_affiliate(org, affiliate).size).to eq 1
            expect(Account.for_affiliate(affiliate, org).size).to eq 1
          end

          it 'should send a notification to the organization' do
            in_browser(:org) do
              visit notifications_path
              expect(page).to have_notification(InviteAcceptedNotification, invite)
            end
          end
        end

        context 'when the affiliate declines the invite' do
          before do
            in_browser(:aff) do
              visit invite_path(invite)
              click_button INVITE_BTN_DECLINE
            end
          end

          it 'should send a notification to the organization' do
            in_browser(:org) do
              visit notifications_path
              expect(page).to have_notification(InviteDeclinedNotification, invite)
            end
          end

          it 'status should be set to declined' do
            expect(invite.reload).to be_declined
          end

        end
      end
    end
  end
end
