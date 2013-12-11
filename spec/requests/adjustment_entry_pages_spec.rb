require 'spec_helper'

describe 'Adjustment Entry', js: true do
  self.use_transactional_fixtures = false

  setup_standard_orgs
  let(:job) { create_my_job(org_admin_user, customer, :org) }
  let(:subcon_job) { Ticket.last }

  let(:org1_org2_acc) { Account.for_affiliate(org, org2).first }
  let(:org2_org1_acc) { Account.for_affiliate(org2, org).first }


  context 'when affiliate is a member' do
    let(:subcon_job) { Ticket.last }
    before do
      in_browser(:org) do
        sign_in org_admin_user
        visit service_call_path(job)
        transfer_job job, org2
      end

      in_browser(:org2) do
        sign_in org_admin_user2
        complete_job subcon_job
      end
    end

    context 'successful creation' do
      let(:entry) { AdjustmentEntry.by_account_and_ticket(org1_org2_acc, job).first }
      let(:org2_entry) { AdjustmentEntry.by_account_and_ticket(org2_org1_acc, subcon_job).first }

      before do
        in_browser(:org) do
          create_adj_entry org1_org2_acc, 10, job
          page.has_selector?('span.alert-success', visible: false)
        end
      end

      it 'should show a success message' do
        pending 'need to find a good way to test this'
      end

      it 'expect entry to be created' do
        expect(entry).to_not be_nil
      end

      it 'expect entry status to be submitted' do
        expect(org2_entry).to be_pending
      end

    end
  end
end