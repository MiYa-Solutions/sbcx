require 'spec_helper'
require 'money-rails/helpers/action_view_extension'

include MoneyRails::ActionViewExtension

describe "Account Pages", js: true do
  self.use_transactional_fixtures = false


  let!(:org_admin_user) { FactoryGirl.create(:member_admin, roles: [Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME), Role.find_by_name(Role::DISPATCHER_ROLE_NAME), Role.find_by_name(Role::TECHNICIAN_ROLE_NAME)]) }
  let!(:org_admin_user2) { FactoryGirl.create(:member_admin, roles: [Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME), Role.find_by_name(Role::DISPATCHER_ROLE_NAME), Role.find_by_name(Role::TECHNICIAN_ROLE_NAME)]) }
  let!(:org_admin_user3) { FactoryGirl.create(:member_admin, roles: [Role.find_by_name(Role::ORG_ADMIN_ROLE_NAME), Role.find_by_name(Role::DISPATCHER_ROLE_NAME), Role.find_by_name(Role::TECHNICIAN_ROLE_NAME)]) }
  let!(:org) { org_admin_user.organization }
  let!(:org2) {
    setup_profit_split_agreement(org_admin_user2.organization, org.becomes(Subcontractor))
    setup_profit_split_agreement(org, org_admin_user2.organization.becomes(Subcontractor)).counterparty
  }
  let!(:org3) do
    setup_profit_split_agreement(org_admin_user3.organization, org_admin_user.organization.becomes(Subcontractor))
    setup_profit_split_agreement(org2, org_admin_user3.organization.becomes(Subcontractor)).counterparty
  end
  let!(:customer) { FactoryGirl.create(:customer, organization: org) }
  let(:job) { create_my_job(org_admin_user, customer, :org) }
  let(:profit_split) { Agreement.our_agreements(org.id, org2.id).first.rules.first }

  let(:bom1) {
    params = { name: "material1", price: 59.99, cost: 13.67, quantity: 1 }
    params[:total_cost] = params[:cost] * params[:quantity] # expected to be 13.67
    params[:total_price] = params[:price] * params[:price] # expeceted to be 119.98
    params[:total_profit] = params[:total_price] - params[:total_cost] # expected to be 106.31
    params
  }
  let(:bom2) {
    params = { name: "material2", price: 100, cost: 10, quantity: 2 }
    params[:total_cost] = params[:cost] * params[:quantity]  # expected to be 20
    params[:total_price] = params[:price] * params[:price] # expected to be 200
    params[:total_profit] = params[:total_price] - params[:total_cost] # expected to be 180
    params

  }

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
    clean org3 unless org3.nil?
  end

  subject { page }


  # todo complete the profit split rule
  # todo add beneficiary for cheque payment upon completion
  # todo create the fixed price rule
  # todo create correction ability using account entries controller
  # todo add collected_by to the payment event
  # todo add a proposal ticket type
  # todo complete the spec below


  describe "not transferred service call" do
    before do
      in_browser(:org) do
        visit service_call_path(job)
        add_bom bom1[:name], bom1[:cost], bom1[:price], bom1[:quantity]
        add_bom bom2[:name], bom2[:cost], bom2[:price], bom2[:quantity]
        click_button JOB_BTN_START
      end
    end

    describe "completed" do
      before do
        click_button JOB_BTN_COMPLETE
      end
      it 'the customer account should be updated with the amount' do
        visit customer_path customer
        should have_selector '.balance', text: "#{bom1[:price]*bom1[:quantity] + bom2[:price]*bom1[:quantity]}"
      end


    end

  end

  describe "transferred service call" do
    let(:subcon_job) { Ticket.last }
    before do
      in_browser(:org) do
        visit service_call_path(job)
        select org2.name, from: JOB_SELECT_SUBCONTRACTOR
        check JOB_CBOX_RE_TRANSFER
        check JOB_CBOX_ALLOW_COLLECTION
        click_button JOB_BTN_TRANSFER
      end

      in_browser(:org2) do
        visit service_call_path(subcon_job)
        click_button JOB_BTN_ACCEPT
        click_button JOB_BTN_START
        add_bom bom1[:name], bom1[:cost], bom1[:price], bom1[:quantity]
        add_bom bom2[:name], bom2[:cost], bom2[:price], bom2[:quantity]

      end

    end
    describe "with profit share" do
      describe "when completed" do
        before do
          in_browser(:org2) do
            click_button JOB_BTN_COMPLETE
          end
        end
        it "customer's account should show service call charge entry" do
          in_browser(:org) do
            visit customer_path customer
            should have_selector '.balance', text: "#{bom1[:total_price] + bom2[:total_price]}"
          end

        end
        it "provider's view should show a payment to subcon entry (withdrawal)" do
          job.reload
          in_browser(:org) do
            visit affiliate_path org2
            should have_selector AFF_SPAN_BALANCE, text: "#{humanized_money_with_symbol -(job.total_profit * (profit_split.rate / 100.0))}"
          end

        end
        it "subcontractor's view should show a payment from provider entry (income)" do
          in_browser(:org2) do
            visit affiliate_path org
            should have_selector AFF_SPAN_BALANCE, text: "#{(subcon_job.total_profit * (profit_split.rate / 100.0))}"
          end

        end

        it "technician's view should show an employee commission (income)"

        describe "when paid" do
          it "should show all applicable payment types as per the agreement"
          describe "with cash payment" do
            it "customer's account should show cash payment entry"
            it "customer's account balance should be zero"
            it "provider's account should show cash collection from subcontractor with a pending status (income)"
            it "subcontractor's account should show cash collection to provider with pending status (withdrawal)"
            it "technician's account should show cash collection for employer with pending status (withdrawal)"
          end
          describe "with credit card payment" do
            it "customer's account should show credit card payment entry"
            it "customer's account balance should be zero"
            it "provider's account should not have additional entries"
            it "subcontractor's account should  not have additional entries"
            it "technician's account should not have additional entries"
          end
          describe "with cheque payment" do
            describe "where the provider is the beneficiary" do
              describe "when collected by the technician" do
                it "customer's account should show a service call cheque payment entry"
                it "provider's account should show a pending cheque collection by subcon entry"
                it "subcontractor's account should show pending cheque collection for prov entry"
                it "technician's account should show pending check collection for employer withdrawal"

                describe "when the cheque is marked as deposited by the subcontractor" do
                  it "provider's account should show the entry as deposited"
                  it "provider's account should now have the amount type as withdrawal"
                  it "subcontractor's account should show the entry as deposited"
                  it "subcontractor's account should now have the amount type as income"
                  it "technician's account should show the entry as deposited"
                  it "technician's account should now have the amount type as income"

                  describe "when provider marks the transaction as cleared" do
                    it "provider's account should show the entry as cleared"
                    it "subcontractor's account should show the entry as cleared"
                    it "technician's account should show the entry as cleared"
                  end
                end
              end

            end

          end
        end

      end
    end


  end


end

