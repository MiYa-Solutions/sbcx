require 'spec_helper'
require 'capybara/rspec'

describe "Service Call pages" do

  # ==============================================================
  # data elements to inspect
  # ==============================================================
  status                  = 'span#service_call_status'
  subcontractor_status    = 'span#service_call_subcontractor_status'
  service_call_started_on = '#service_call_started_on_text'
  # ==============================================================
  # buttons to click and inspect
  # ==============================================================
  transfer_btn            = '#service_call_transfer_btn'
  transfer_btn_selector   = 'service_call_transfer_btn'
  dispatch_btn            = '#service_call_dispatch_btn'
  dispatch_btn_selector   = 'service_call_dispatch_btn'
  create_btn              = 'service_call_create_btn'
  create_btn_selector     = 'service_call_create_btn'
  accept_btn              = '#accept_service_call_btn'
  accept_btn_selector     = 'accept_service_call_btn'
  reject_btn              = '#reject_service_call_btn'
  reject_btn_selector     = 'reject_service_call_btn'


  describe "with Org Admin" do

    let(:org_admin_user) { FactoryGirl.create(:org_admin) }
    let(:org_admin_user2) { FactoryGirl.create(:org_admin) }
    let(:org) { org_admin_user.organization }
    let(:org2) { org_admin_user2.organization }

    let(:provider) {
      prov = FactoryGirl.create(:provider)
      org.providers << prov
      prov
    }

    let(:subcontractor) {
      subcontractor = org2.becomes(Subcontractor)
      org.subcontractors << subcontractor
      subcontractor
    }

    let(:customer) { FactoryGirl.create(:customer, organization: org) }

    before do
      in_browser(:org) do
        sign_in org_admin_user
      end

      in_browser(:org2) do
        sign_in org_admin_user2
      end


    end

    subject { page }

    describe "new service call page" do

      #initialize orgs provider, customer, etc.
      before do
        provider.save!
        customer.save!
        in_browser(:org) do
          with_user(org_admin_user) do
            visit new_service_call_path
          end
        end

      end


      it "should have a started on label" do
        in_browser(:org) do
          should have_selector(service_call_started_on)
        end

      end


      it "should be created successfully" do
        in_browser(:org) do
          expect do
            select provider.name, from: 'service_call_provider_id'
            select customer.name, from: 'service_call_customer_id'
            click_button create_btn
          end.to change(ServiceCall, :count).by(1)
        end


      end


    end

    describe "show service call" do
      let(:service_call) { FactoryGirl.create(:my_service_call, organization: org, customer: customer, subcontractor: nil) }

      before do
        subcontractor.save
        in_browser(:org) do
          visit service_call_path service_call
        end

      end
      it { should have_selector(transfer_btn, value: I18n.t('activerecord.state_machines.my_service_call.status.events.transfer')) }
      it { should have_selector(dispatch_btn, value: I18n.t('activerecord.state_machines.my_service_call.status.events.dispatch')) }
      it { should have_selector(status) }


      describe "transfer my service call" do
        # transfer the service call
        before do
          in_browser(:org) do
            select subcontractor.name, from: 'service_call_subcontractor'
            click_button transfer_btn_selector
          end
          @subcon_service_call = ServiceCall.find_by_organization_id_and_ref_id(subcontractor.id, service_call.ref_id)
        end

        it "should change the status to transferred localized" do
          should have_selector(status, text: I18n.t('activerecord.state_machines.my_service_call.status.states.transferred'))
        end

        it "should change the subcontractor status to pending localized" do
          should have_selector(subcontractor_status, text: I18n.t('activerecord.state_machines.my_service_call.subcontractor_status.states.pending'))
        end

        describe "subcontractor browser" do
          let(:subcon_service_call) { ServiceCall.find_by_organization_id_and_ref_id(subcontractor.id, service_call.ref_id) }

          before(:each) do
            in_browser(:org2) do
              visit service_call_path subcon_service_call
            end


          end

          it "should show up in the subcontractors gui with a locelized received_new status" do
            should have_selector(status, text: I18n.t('activerecord.state_machines.transferred_service_call.status.states.received_new'))
          end

          it "should have a subcontractor status with localized na" do
            should have_selector(subcontractor_status, text: I18n.t('activerecord.state_machines.transferred_service_call.subcontractor_status.states.na'))
          end

          it "should have the right provider " do
            should have_selector('#provider', text: org.name)
          end

          it "should allow to accept the service call" do
            should have_selector(accept_btn, value: I18n.t('activerecord.state_machines.transferred_service_call.status.events.accept'))
          end


        end


        describe "subcontractor accepts the service call" do

          # accept the service call
          before do
            in_browser(:org2) do
              visit service_call_path @subcon_service_call
              click_button accept_btn_selector
            end

            in_browser(:org) { visit service_call_path service_call }
          end

          it "status remains transferred" do
            should have_selector(status, text: I18n.t('activerecord.state_machines.my_service_call.status.states.transferred'))

          end
          it "subcontractor status changes to accepted" do
            should have_selector(subcontractor_status, text: I18n.t('activerecord.state_machines.my_service_call.subcontractor_status.states.accepted'))
          end
        end

        describe "subcontractor rejects the service call" do


          before do
            in_browser(:org2) do
              visit service_call_path @subcon_service_call
              click_button reject_btn_selector
            end

            in_browser(:org) { visit service_call_path service_call }
          end

          it "status remains transferred" do
            should have_selector(status, text: I18n.t('activerecord.state_machines.my_service_call.status.states.transferred'))

          end
          it "subcontractor status changes to rejected" do
            should have_selector(subcontractor_status, text: I18n.t('activerecord.state_machines.my_service_call.subcontractor_status.states.rejected'))
          end
        end
      end

    end

  end

end
