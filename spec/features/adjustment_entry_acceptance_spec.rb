require 'spec_helper'
require_relative '../../spec/features/acceptance_testing_shared_stuff'

describe 'Adjustment Entry Acceptance', js: true do
  self.use_transactional_fixtures = false

  include_context 'acceptance tests with two members', :setup_flat_fee_agreement, {}
  include_context 'create job and transfer to org2'

  before do
    in_browser(:org2) do
      complete_job subcon_job
    end
    in_browser(:org) do
      create_adj_entry org1_org2_acc, 50, job
    end
  end

  it 'should create adjustment entry successfully' do
    in_browser(:org) do
      expect(page).to have_selector('li.add_button span.alert-success')
    end
  end

  it 'the recipient should have a notification' do
    in_browser(:org2) do
      visit notifications_path
      expect(page).to have_content(I18n.t('notifications.account_adjusted_notification.content', affiliate: org.name))
    end
  end

  it 'initiator account synch status is set to Adjustment Submitted' do
    in_browser(:org) do
      visit affiliate_path(org2)
      expect(page).to have_synch_status('Adjustment Submitted')
    end
  end

  it 'recipient account synch status is set to Adjustment Submitted' do
    in_browser(:org2) do
      visit affiliate_path(org)
      expect(page).to have_synch_status('Adjustment Submitted')
    end
  end

  context 'recipient view of the adjustment entry' do
    before do
      in_browser(:org2) do
        visit notifications_path
        page.find(AE_ADJUSTED_NOTIF_LINK).click
      end

    end

    it 'should show the adjustment entry' do
      expect(page).to have_selector('td#accounting_entry_id')
    end

    it 'should have the accept and reject buttons' do
      expect(page).to have_button(AE_BTN_ACCEPT)
      expect(page).to have_button(AE_BTN_REJECT)
    end
  end

  context 'when the recipient accepts the notification' do
    before do
      in_browser(:org2) do
        visit notifications_path
        page.find(AE_ADJUSTED_NOTIF_LINK).click
        click_button AE_BTN_ACCEPT
      end
    end

    it 'should show success message' do
      expect(page).to have_success_message
    end

    it 'the entry status should be accepted' do
      expect(page).to have_entry_status('Accepted')

    end

    it 'the initiator gets a notification' do

      in_browser(:org) do
        visit notifications_path
        expect(page).to have_content(I18n.t('notifications.acc_adj_accepted_notification.content', affiliate: org2.name))
      end

    end

    it 'recipient account synch status is set to Adjustment Submitted' do
      in_browser(:org2) do
        visit affiliate_path(org)
        expect(page).to have_synch_status('In Synch')
      end
    end
    it 'initiator account synch status is set to Adjustment Submitted' do
      in_browser(:org) do
        visit affiliate_path(org2)
        expect(page).to have_synch_status('In Synch')
      end
    end

  end

  context 'when the recipient rejects the notification' do
    before do
      in_browser(:org2) do
        visit notifications_path
        page.find(AE_ADJUSTED_NOTIF_LINK).click
        click_button AE_BTN_REJECT
      end
    end

    it 'should show success message' do
      expect(page).to have_success_message
    end

    it 'the entry status should be accepted' do
      expect(page).to have_entry_status('Rejected')

    end

    it 'the initiator gets a notification' do

      in_browser(:org) do
        visit notifications_path
        expect(page).to have_content(I18n.t('notifications.acc_adj_rejected_notification.content', affiliate: org2.name))
      end

    end

    it 'recipient account synch status is set to Adjustment Submitted' do
      in_browser(:org2) do
        visit affiliate_path(org)
        expect(page).to have_synch_status('Out Of Synch')
      end
    end

    it 'initiator account synch status is set to Adjustment Submitted' do
      in_browser(:org) do
        visit affiliate_path(org2)
        expect(page).to have_synch_status('Out Of Synch')
      end
    end

    it 'the initiator should see a cancel button' do
      in_browser(:org) do
        visit notifications_path
        page.find(AE_REJECTED_NOTIF_LINK).click

        expect(page).to have_button(AE_BTN_CANCEL)
        expect(page).to_not have_button(AE_BTN_ACCEPT)
        expect(page).to_not have_button(AE_BTN_REJECT)
      end
    end

    context 'when the initiator cancels the adjustment' do
      before do
        in_browser(:org) do
          visit notifications_path
          page.find(AE_REJECTED_NOTIF_LINK).click
          click_button AE_BTN_CANCEL
        end
      end

      it 'initiator account synch status is set to In Synch' do
        in_browser(:org) do
          visit affiliate_path(org2)
          expect(page).to have_synch_status('In Synch')
        end
      end

      it 'recipient account synch status is set to In Synch' do
        in_browser(:org2) do
          visit affiliate_path(org)
          expect(page).to have_synch_status('In Synch')
        end
      end

    end

  end


end