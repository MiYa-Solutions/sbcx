require 'spec_helper'

FF_INPUT_SUBCON_FEE     = 'service_call_properties_subcon_fee'
FF_INPUT_PROV_FEE       = 'service_call_properties_provider_fee'
FF_CBOX_BOM_REIMBU      = 'service_call_properties_bom_reimbursement'
FF_CBOX_PROV_BOM_REIMBU = 'service_call_properties_prov_bom_reimbursement'

describe 'Transfer with a flat fee agreement', js: true do
  self.use_transactional_fixtures = false

  let(:user) { FactoryGirl.create(:member_admin, roles: [Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME), Role.find_by_name(Role::DISPATCHER_ROLE_NAME), Role.find_by_name(Role::TECHNICIAN_ROLE_NAME)]) }
  let(:org) { user.organization }
  let(:subcon) { setup_flat_fee_agreement(org, FactoryGirl.create(:subcontractor)).counterparty }
  let(:account) { Account.for_affiliate(org, subcon).first }
  let(:agreement) { Agreement.our_agreements(org, subcon).first }
  let(:the_rule) { agreement.rules.first }
  let(:job) { FactoryGirl.create(:my_service_call, organization: org, subcontractor: nil) }

  let(:bom1_cost) { 53.49 }
  let(:bom1_price) { 153 }
  let(:bom1_qty) { 2 }

  let(:bom2_cost) { 0.49 }
  let(:bom2_price) { 0.75 }
  let(:bom2_qty) { 1 }
  let(:subcon_flat_fee) { Money.new_with_amount(10) }


  context 'when transferring to a local subcon' do

    before do
      in_browser(:org) do
        sign_in(user)
        visit service_call_path(job)
        transfer_job(job, subcon, agreement) do
          check FF_CBOX_BOM_REIMBU
          fill_in FF_INPUT_SUBCON_FEE, with: '2'
        end
      end
      job.reload
    end

    it 'should store the transfer parameters' do
      expect(job.properties).to_not be_empty
      expect(job.properties['subcon_fee']).to eq '2'
      expect(job.properties['bom_reimbursement']).to eq '1'
    end
  end

  context 'when transferring to a member subcon' do
    let(:mem_subcon) { setup_flat_fee_agreement(org, FactoryGirl.create(:member_admin, roles: [Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME), Role.find_by_name(Role::DISPATCHER_ROLE_NAME), Role.find_by_name(Role::TECHNICIAN_ROLE_NAME)]).organization).counterparty }
    let(:account) { Account.for_affiliate(org, mem_subcon).first }
    let(:agreement) { Agreement.our_agreements(org, mem_subcon).first }
    let(:the_rule) { agreement.rules.first }
    let(:subcon_job) { Ticket.find_by_organization_id_and_ref_id(mem_subcon.id, job.ref_id) }

    before do
      in_browser(:org) do
        sign_in(user)
        visit service_call_path(job)
        transfer_job(job, mem_subcon, agreement) do
          check FF_CBOX_BOM_REIMBU
          fill_in FF_INPUT_SUBCON_FEE, with: '2'
        end
      end
      subcon_job.reload
    end

    it 'subcon job has transfer attributes' do
      expect(subcon_job.properties).to_not be_empty
      expect(subcon_job.properties['provider_fee']).to eq '2'
      expect(subcon_job.properties['bom_reimbursement']).to eq '1'
    end


  end

  context 'when transferred from a local provider' do

    let!(:agreement) { setup_flat_fee_agreement(FactoryGirl.create(:provider), org) }
    let(:provider) { agreement.organization }
    let(:local_job) { org.service_calls.where(provider_id: provider.id).first }

    context 'with bom reimbursement' do
      before do
        in_browser(:org) do
          sign_in(user)
          visit new_service_call_path
          select provider.name, from: JOB_SELECT_PROVIDER
          select agreement.name, from: JOB_SELECT_PROVIDER_AGR
          page.has_css? FF_CBOX_PROV_BOM_REIMBU
          check FF_CBOX_PROV_BOM_REIMBU
          fill_in FF_INPUT_PROV_FEE, with: 10
          fill_autocomplete 'service_call_customer_name', with: job.customer.name[0..3]
          click_button JOB_BTN_CREATE
        end

      end

      it 'should be created successfully' do
        expect(page).to have_success_message
      end

      it 'the created job should have transfer props' do
        expect(local_job.properties['provider_fee']).to eq '10'
        expect(local_job.properties['prov_bom_reimbursement']).to eq '1'
      end

      context 'when completing job, the balance should reflect the bom reimbursement' do
        before do
          in_browser(:org) do
            visit service_call_path(local_job)
            click_button JOB_BTN_ACCEPT
            click_button JOB_BTN_START
            add_bom "part1", 10, 100, 1
            add_bom "part2", 20, 200, 1
            page.has_content? "part2"
            click_button JOB_BTN_COMPLETE
          end
        end

        it 'account balance should reflect bom reimbursement' do
          expect(Account.for_affiliate(org, provider).first.balance).to eq Money.new_with_amount(40)
        end
      end
    end

    context 'without bom reimbursement' do
      before do
        in_browser(:org) do
          sign_in(user)
          visit new_service_call_path
          select provider.name, from: JOB_SELECT_PROVIDER
          select agreement.name, from: JOB_SELECT_PROVIDER_AGR
          page.has_css? FF_CBOX_PROV_BOM_REIMBU
          uncheck FF_CBOX_PROV_BOM_REIMBU
          fill_in FF_INPUT_PROV_FEE, with: 10
          fill_autocomplete 'service_call_customer_name', with: job.customer.name[0..3]
          click_button JOB_BTN_CREATE
        end

      end

      it 'should be created successfully' do
        expect(page).to have_success_message
      end

      it 'the created job should have transfer props' do
        expect(local_job.properties['provider_fee']).to eq '10'
        expect(local_job.properties['prov_bom_reimbursement']).to eq '1'
      end

      context 'when completing job, the balance should reflect the bom reimbursement' do
        before do
          in_browser(:org) do
            visit service_call_path(local_job)
            click_button JOB_BTN_ACCEPT
            click_button JOB_BTN_START
            add_bom "part1", 10, 100, 1
            add_bom "part2", 20, 200, 1
            page.has_content? "part2"
            click_button JOB_BTN_COMPLETE
          end
        end

        it 'account balance should reflect bom reimbursement' do
          expect(Account.for_affiliate(org, provider).first.balance).to eq Money.new_with_amount(10)
        end
      end
    end
  end

end